#!/bin/bash
set -euo pipefail

mkdir -p /app/test-results /app/coverage/html-report

echo "--- Waiting for API to be available ---"
until curl -k --silent https://cardvalidation-api:7135/swagger/index.html > /dev/null; do
  echo "Waiting for cardvalidation-api..."
  sleep 3
done

echo "--- Restore & Build (regenerates Reqnroll/SpecFlow code-behind) ---"
dotnet restore CardValidation.sln
dotnet build CardValidation.Tests/CardValidation.Tests.csproj -c Debug

echo "--- Running ALL tests ---"
set +e
dotnet test CardValidation.Tests/CardValidation.Tests.csproj \
  -c Debug \
  --results-directory /app/test-results \
  --logger "trx;LogFileName=unit_test_results.trx" \
  --logger "html;LogFileName=unit_test_results.html"
  --collect:"XPlat Code Coverage"
TEST_EXIT=$?
set -e

COV_FILE=$(find /app/test-results -maxdepth 3 -type f -name "coverage.cobertura.xml" | head -n1)

echo "--- Generating coverage HTML ---"
if [ -n "$COV_FILE" ] && [ -f "$COV_FILE" ]; then
  reportgenerator \
    -reports:/app/test-results/coverage.cobertura.xml \
    -targetdir:/app/coverage/html-report \
    -reporttypes:HtmlInline_AzurePipelines

  echo "Coverage HTML at /app/coverage/html-report/index.html"
else
  echo "No coverage file found from XPlat collector under /app/test-results"
fi

echo "TRX at /app/test-results/unit_test_results.trx"
exit $TEST_EXIT
