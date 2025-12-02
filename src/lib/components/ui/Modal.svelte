<script lang="ts">
  import { X } from 'lucide-svelte';

  interface Props {
    open?: boolean;
    title: string;
    onClose: () => void;
    children?: any;
  }

  let { open = $bindable(false), title, onClose, children }: Props = $props();

  function handleBackdropClick(event: MouseEvent) {
    if (event.target === event.currentTarget) {
      onClose();
    }
  }

  function handleEscape(event: KeyboardEvent) {
    if (event.key === 'Escape') {
      onClose();
    }
  }
</script>

{#if open}
  <div
    class="modal-backdrop fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
    onclick={handleBackdropClick}
    onkeydown={handleEscape}
    role="dialog"
    aria-modal="true"
    aria-labelledby="modal-title"
  >
    <div class="modal-content bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] flex flex-col">
      <!-- Header -->
      <div class="flex items-center justify-between p-6 border-b border-gray-200">
        <h2 id="modal-title" class="text-xl font-semibold text-gray-900">{title}</h2>
        <button
          class="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          onclick={onClose}
          aria-label="Close modal"
        >
          <X class="w-5 h-5 text-gray-600" />
        </button>
      </div>

      <!-- Content -->
      <div class="flex-1 overflow-y-auto p-6">
        {@render children?.()}
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    animation: fadeIn 0.2s ease-out;
  }

  .modal-content {
    animation: slideUp 0.2s ease-out;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  @keyframes slideUp {
    from {
      transform: translateY(20px);
      opacity: 0;
    }
    to {
      transform: translateY(0);
      opacity: 1;
    }
  }
</style>
