#!/bin/bash
REPO=$1
USER="thunderdragonshoujo"

# Step 1: Create Next.js app
create_next_app() {
  echo "Creating Next.js app..."
  npx create-next-app@latest $REPO
}

# Step 2: Move into the directory
move_into_directory() {
  echo "Moving into the app directory..."
  cd $REPO || exit
}

# Step 3: set up static output
config_next_config() {
  cat > next.config.js <<EOL
  /** @type {import('next').NextConfig} */
  const nextConfig = {
  basePath: "/${REPO}",
  output: "export",
  reactStrictMode: true,
};

module.exports = nextConfig;
EOL
}

# Step 4: Configure Tailwind in tailwind.config.js
configure_tailwind() {
  echo "Configuring Tailwind in tailwind.config.js..."
  cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
    './app/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOL
}

# Step 5: Add Tailwind CSS to globals.css
add_tailwind_to_globals() {
  echo "Adding Tailwind CSS to styles/globals.css..."
  cat > styles/globals.css <<EOL
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL
}

# Step 6: Copy hero image to public folder
copy_hero_image() {
  echo "Copying hero image to public folder..."
  mkdir -p public
  cp ~/heroimage.webp public/
}

# Step 7: Create the Button component
create_button_component() {
  echo "Creating Button component..."
  mkdir -p src/components
  cat > src/components/Button.tsx <<EOL
import React from 'react';

interface ButtonProps {
  text: string;
  href: string;
}

const Button: React.FC<ButtonProps> = ({ text, href }) => {
  return (
    <a
      href={href}
      className="inline-block px-6 py-3 bg-blue-500 text-white text-lg font-bold rounded-full hover:bg-blue-600 transition duration-300 ease-in-out transform hover:scale-105"
    >
      {text}
    </a>
  );
};

export default Button;
EOL
}

# Step 8: Create hero landing page with the Button component
create_hero_landing_page() {
  echo "Creating hero landing page..."
  mkdir -p src/app
  cat > src/app/page.tsx <<EOL
import Image from 'next/image';
import Button from '../components/Button';

export default function Home() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-50">
      {/* Logo */}
      <div className="py-5">
        <Image src="/logo-placeholder.png" alt="Logo" width={100} height={100} />
      </div>
      
      {/* Hero Section */}
      <div className="text-center max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <Image src="/heroimage.webp" alt="Hero Image" className="rounded-lg shadow-lg" width={800} height={400} />
        <h1 className="text-4xl font-bold mt-6 mb-4 text-gray-800">We Build Landing Pages</h1>
        
        {/* Marketing Bullets */}
        <ul className="space-y-4 text-lg text-gray-600">
          <li className="flex items-center">
            <svg className="w-6 h-6 text-blue-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
            </svg>
            Fast and responsive design tailored for your needs
          </li>
          <li className="flex items-center">
            <svg className="w-6 h-6 text-blue-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
            </svg>
            Scalable solutions built to grow with your business
          </li>
          <li className="flex items-center">
            <svg className="w-6 h-6 text-blue-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
            </svg>
            Seamless integration with your existing tools
          </li>
        </ul>
        
        {/* Call-to-Action Button */}
        <div className="mt-6">
          <Button text="Learn More" href="https://www.ace8.io" />
        </div>
      </div>
    </div>
  );
}
EOL
}

# Step 9: Create a placeholder logo
create_placeholder_logo() {
  echo "Creating placeholder logo..."
  cat > public/logo-placeholder.png <<EOL
# Placeholder logo, generate or download a suitable image and place it here
EOL
}

# Step 10: Run the Next.js app
run_app() {
  echo "Running Next.js app..."
  npm run dev &
}

#step 11: set up git
git_setup() {
  gh repo create $REPO --private --source=. --remote=upstream
  sleep 4
}

git_actions_node(){
  mkdir -p .github/workflows/setup-node/
  cat > .github/workflows/setup-node/action.yml <<'EOL'
# File: .github/workflows/setup-node/action.yml
name: setup-node
description: "Setup Node.js - Cache dependencies - Install dependencies"
runs:
  using: "composite"
  steps:
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: 20

    - name: Cache dependencies
      id: cache_dependencies
      uses: actions/cache@v3
      with:
        path: node_modules
        key: node-modules-${{ hashFiles('package-lock.json') }}

    - name: Install dependencies
      shell: bash
      if: steps.cache_dependencies.outputs.cache-hit != 'true'
      run: npm ci
EOL
}

git_actions_publish(){
  cat >.github/workflows/publish.yml <<'EOL_ga'
# File: .github/workflows/publish.yml
name: publish-to-github-pages
on:
  push:
    branches:
      - gh-pages

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js - Cache dependencies - Install dependencies
        uses: ./.github/workflows/setup-node

      - name: Setup Pages
        uses: actions/configure-pages@v4
        with:
          static_site_generator: next

      - name: Build with Next.js
        run: npx next build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./export

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    runs-on: ubuntu-latest
    needs: build

    steps:
      - name: Publish to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOL_ga
}

git_push() {
  git add .
  git commit -m "Initial commit with static HTML page"
  git checkout -b gh-pages
  git push -u upstream gh-pages
  echo "ALL DONE"
  /mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe "https://${USER}.github.io/${REPO}/"
}

# Main function to orchestrate the steps
main() {
  create_next_app
  move_into_directory
  config_next_config
  #configure_tailwind
  #add_tailwind_to_globals
  copy_hero_image
  create_button_component
  create_hero_landing_page
  create_placeholder_logo
  run_app
  git_setup
  git_actions_node
  git_actions_publish
  git_push
}

# Start the script by calling the main function
main

