#!/bin/bash
set -e

echo "🔍 Running Semgrep..."
semgrep --config=auto --json > /workspace/semgrep-report.json || echo "Semgrep failed"

echo "🔍 Running Trivy..."
trivy fs --scanners vuln,secret,license --format json --output /workspace/trivy-report.json /workspace || echo "Trivy failed"

echo "✅ Reports generated in /workspace:"
ls -lh /workspace/*.json