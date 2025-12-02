# Deployment Guide

This guide explains how to deploy the Svelte Web Builder to GitHub Pages.

## Prerequisites

- GitHub repository
- GitHub Actions enabled
- Pages enabled in repository settings

## GitHub Pages Deployment

### 1. Configure Repository Settings

1. Go to your GitHub repository
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **GitHub Actions**
4. Save the settings

### 2. Update Base Path

In `svelte.config.js`, update the base path to match your repository name:

```javascript
paths: {
  base: process.env.NODE_ENV === 'production' ? '/your-repo-name' : ''
}
```

Replace `/your-repo-name` with your actual repository name (e.g., `/web-builder`).

### 3. Automatic Deployment

The deployment pipeline is configured to run automatically when you push to the `main` or `master` branch.

```bash
git push origin main
```

The GitHub Actions workflow will:
1. Install dependencies
2. Build the static site
3. Deploy to GitHub Pages

### 4. Access Your Site

After deployment (usually 2-5 minutes), your site will be available at:
```
https://yourusername.github.io/your-repo-name
```

## Manual Deployment

You can also trigger deployment manually:

1. Go to **Actions** tab in your repository
2. Select **Deploy to GitHub Pages** workflow
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

## Local Testing

Before deploying, test the production build locally:

```bash
# Build for production
npm run build

# Preview the build
npm run preview
```

Visit `http://localhost:4173` to test the production build.

## Troubleshooting

### Build Fails

- Check that all dependencies are installed: `npm install`
- Verify TypeScript compilation: `npm run check`
- Check for build errors in the GitHub Actions logs

### 404 Errors

- Ensure the `base` path in `svelte.config.js` matches your repository name
- Check that the `.nojekyll` file exists in the `static` folder
- Verify that GitHub Pages is enabled in repository settings

### Assets Not Loading

- Make sure the `base` path is correctly set
- Check that all asset paths use `%sveltekit.assets%` prefix
- Verify the build output in the `build` folder

## Alternative Deployment Options

### Vercel

1. Import your repository to Vercel
2. Configure build settings:
   - **Build Command**: `npm run build`
   - **Output Directory**: `build`
   - **Install Command**: `npm install`
3. Deploy

### Netlify

1. Import your repository to Netlify
2. Configure build settings:
   - **Build Command**: `npm run build`
   - **Publish Directory**: `build`
3. Deploy

### Self-Hosted

1. Build the project: `npm run build`
2. Copy the `build` folder to your web server
3. Configure your server to serve the static files

## Environment Variables

For production deployments, you can set environment variables:

- `NODE_ENV=production` - Enables production mode
- Add other environment variables as needed in GitHub Actions secrets

## Security Notes

- Never commit sensitive data or API keys
- Use GitHub Secrets for sensitive environment variables
- Review the `.gitignore` file to ensure sensitive files are excluded

## Support

For issues with deployment, check:
- [SvelteKit Static Adapter Docs](https://kit.svelte.dev/docs/adapter-static)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- Repository Issues tab
