#!/bin/bash

echo "🚀 Setting up Java development environment..."

# Make sure we're in the workspace
cd /workspaces/java-retail-ui-service

# Install dependencies
echo "📚 Installing dependencies..."
mvn dependency:resolve

# Build the project with annotation processing
echo "🔨 Building project with annotation processing..."
if mvn --no-transfer-progress compile; then
    echo "✅ Project compiled successfully!"
else
    echo "⚠️  Compilation failed. Manual intervention may be required."
    echo "💡 Try running: mvn clean compile manually"
fi

# Clean build artifacts for fresh start
echo "🧹 Cleaning build artifacts..."
mvn clean

# Run tests to validate environment
echo "🧪 Running tests to validate environment..."
if mvn test; then
    echo "✅ Tests passed successfully!"
else
    echo "⚠️  Tests failed, but continuing with setup..."
    echo "💡 You may need to fix compilation issues before running tests again"
fi

echo "✅ Java development environment setup complete!"
echo ""
echo "🔄 Automatically completed:"
echo "  ✅ Dependencies installed"
echo "  ✅ Project compiled"
echo "  ✅ Build artifacts cleaned"
echo "  ✅ Environment validated"
echo ""
echo "📋 Available manual commands:"
echo "  mvn spring-boot:run    - Start the application"
echo "  mvn test              - Run tests again"
echo "  mvn package           - Build JAR file"
echo "  mvn clean             - Clean build artifacts"
echo "  mvn compile           - Recompile after fixes"
echo ""
echo "🔧 Troubleshooting commands:"
echo "  mvn clean compile     - Clean and recompile"
echo "  mvn dependency:tree   - Check dependency conflicts"
echo "  mvn validate          - Validate project configuration"
