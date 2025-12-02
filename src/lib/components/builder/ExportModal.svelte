<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { generateHTML, downloadFile } from '$lib/utils/export';
  import Modal from '$lib/components/ui/Modal.svelte';
  import { Download, Copy, Check } from 'lucide-svelte';

  interface Props {
    open?: boolean;
    onClose: () => void;
  }

  let { open = $bindable(false), onClose }: Props = $props();

  const htmlCode = $derived(generateHTML(canvasStore.components));
  let copied = $state(false);

  function handleDownload() {
    downloadFile(htmlCode, 'index.html', 'text/html');
  }

  async function handleCopy() {
    try {
      await navigator.clipboard.writeText(htmlCode);
      copied = true;
      setTimeout(() => (copied = false), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  }
</script>

<Modal bind:open {onClose} title="Export Code">
  {#snippet children()}
    <div class="space-y-4">
      <div class="flex items-center justify-between mb-4">
        <p class="text-sm text-gray-600">
          Your design has been exported as HTML. You can copy the code or download it as a file.
        </p>
        <div class="flex gap-2">
          <button class="btn btn-secondary flex items-center gap-2" onclick={handleCopy}>
            {#if copied}
              <Check class="w-4 h-4" />
              Copied!
            {:else}
              <Copy class="w-4 h-4" />
              Copy
            {/if}
          </button>
          <button class="btn btn-primary flex items-center gap-2" onclick={handleDownload}>
            <Download class="w-4 h-4" />
            Download
          </button>
        </div>
      </div>

      <div class="bg-gray-900 rounded-lg p-4 overflow-x-auto">
        <pre class="text-sm text-gray-100"><code>{htmlCode}</code></pre>
      </div>
    </div>
  {/snippet}
</Modal>
