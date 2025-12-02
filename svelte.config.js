import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://kit.svelte.dev/docs/integrations#preprocessors
	// for more information about preprocessors
	preprocess: vitePreprocess(),

	kit: {
		// adapter-static configuration for GitHub Pages
		adapter: adapter({
			// default options
			pages: 'build',
			assets: 'build',
			fallback: 'index.html',
			precompress: false,
			strict: true
		}),
		paths: {
			// Update this with your repo name for GitHub Pages
			// Format: base: '/repo-name'
			base: process.env.NODE_ENV === 'production' ? '/web-builder' : ''
		}
	}
};

export default config;
