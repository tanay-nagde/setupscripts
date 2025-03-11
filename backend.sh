#!/bin/bash

# Create project directory
mkdir backend && cd backend

# Initialize package.json
npm init -y

# Enable ESM (ES Modules) in package.json
jq '. + { "type": "module" }' package.json > temp.json && mv temp.json package.json

# Install dependencies
npm install express mongoose dotenv cors jsonwebtoken bcrypt cookie-parser zod uuid resend

# Install dev dependencies
npm install -D typescript ts-node-dev @types/node @types/express @types/jsonwebtoken @types/bcrypt @types/cookie-parser @types/cors

# Setup TypeScript config
npx json -I -f tsconfig.json -e '
  this.compilerOptions = {
    "target": "ES6",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  }
'

# Create basic folder structure
mkdir src && mkdir src/controllers src/models src/routes src/middleware

# Create entry file
cat <<EOF > src/index.ts
import express from "express";
import dotenv from "dotenv";

dotenv.config();
const app = express();

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello, ESM with TypeScript!");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOF

# Add scripts in package.json
jq '.scripts += { "dev": "ts-node-dev --loader ts-node/esm --respawn src/index.ts" }' package.json > temp.json && mv temp.json package.json

echo "✅ Backend setup complete! Run 'npm run dev' to start the server."
