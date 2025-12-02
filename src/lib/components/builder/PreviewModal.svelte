<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { generateHTML } from '$lib/utils/export';
  import Modal from '$lib/components/ui/Modal.svelte';

  interface Props {
    open?: boolean;
    onClose: () => void;
  }

  let { open = $bindable(false), onClose }: Props = $props();

  const htmlCode = $derived(generateHTML(canvasStore.components));
  let iframeElement = $state<HTMLIFrameElement | null>(null);

  $effect(() => {
    if (iframeElement && open) {
      const doc = iframeElement.contentDocument;
      if (doc) {
        doc.open();
        doc.write(htmlCode);
        doc.close();
      }
    }
  });
</script>

<Modal bind:open {onClose} title="Preview">
  {#snippet children()}
    <div class="space-y-4">
      <p class="text-sm text-gray-600">
        This is how your page will look when published. The preview is fully interactive.
      </p>

      <div class="border border-gray-200 rounded-lg overflow-hidden bg-white" style="height: 600px;">
        <iframe
          bind:this={iframeElement}
          class="w-full h-full"
          title="Preview"
          sandbox="allow-same-origin"
        ></iframe>
      </div>
    </div>
  {/snippet}
</Modal>
