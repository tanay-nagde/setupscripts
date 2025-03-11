#!/bin/bash

# Exit on error
set -e

echo "🚀 Setting up backend... latest"

# Create project folder and navigate into it
mkdir -p backend && cd backend

# Initialize npm
npm init -y

# Install latest stable dependencies
npm install express mongoose cors dotenv bcrypt jsonwebtoken cookie-parser uuid zod

# Install latest stable dev dependencies
npm install -D typescript ts-node-dev @types/express @types/mongoose @types/cors @types/node @types/jsonwebtoken @types/bcrypt @types/cookie-parser

# Initialize TypeScript configuration
npx tsc --init

# Modify tsconfig.json for ES module support
npx json -I -f tsconfig.json -e '
  this.compilerOptions.module="NodeNext";
  this.compilerOptions.moduleResolution="NodeNext";
  this.compilerOptions.outDir="dist";
  this.compilerOptions.rootDir="src";
  this.compilerOptions.strict=true;
  this.compilerOptions.esModuleInterop=true;
  this.compilerOptions.forceConsistentCasingInFileNames=true;
  this.compilerOptions.skipLibCheck=true;
  this.include=["src"];
'

# Modify package.json for ESM and add scripts
npx json -I -f package.json -e '
  this.type="module";
  this.scripts={
    "dev": "ts-node-dev --loader ts-node/esm --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
'

# Create source directory and index file
mkdir -p src
cat <<EOT > src/index.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("🚀 Backend is running...");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`🔥 Server running on port \${PORT}\`));
EOT

echo "✅ Backend setup complete! Run 'npm run dev' to start the server."
