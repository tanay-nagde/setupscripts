#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🚀 Setting up a TypeScript Express backend..."

# Create a backend directory
mkdir backend && cd backend

# Initialize a Node.js project
npm init -y

# Install backend dependencies
npm install express mongoose cors dotenv

# Install development dependencies
npm install -D typescript ts-node nodemon @types/node @types/express @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint prettier

# Initialize TypeScript
npx tsc --init

# Modify tsconfig.json (enable strict mode and module resolution)
cat <<EOT > tsconfig.json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "CommonJS",
    "rootDir": "./src",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true
  }
}
EOT

# Create src directory
mkdir src

# Create a basic Express server
cat <<EOT > src/server.ts
import express from "express";
import cors from "cors";
import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

app.get("/", (req, res) => {
  res.send("Hello, TypeScript + Express!");
});

app.listen(PORT, () => {
  console.log(\`🚀 Server is running on port \${PORT}\`);
});

// MongoDB Connection
const MONGO_URI = process.env.MONGO_URI || "";
mongoose
  .connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch((err) => console.error("❌ MongoDB connection error:", err));
EOT

# Create a .env file
cat <<EOT > .env
PORT=5000
MONGO_URI=mongodb://localhost:27017/mydatabase
EOT

# Create a .gitignore file
cat <<EOT > .gitignore
node_modules
dist
.env
EOT

# Create a basic ESLint configuration
cat <<EOT > .eslintrc.json
{
  "env": {
    "es2021": true,
    "node": true
  },
  "extends": ["eslint:recommended", "plugin:@typescript-eslint/recommended"],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": ["@typescript-eslint"],
  "rules": {}
}
EOT

# Add scripts to package.json
npx json -I -f package.json -e 'this.scripts={
  "dev": "nodemon src/server.ts",
  "build": "tsc",
  "start": "node dist/server.js"
}'

echo "✅ Backend setup completed! Run 'npm run dev' to start the server 🚀"
