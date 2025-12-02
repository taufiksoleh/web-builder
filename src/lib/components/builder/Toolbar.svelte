<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import {
    Undo,
    Redo,
    Download,
    Save,
    Eye,
    Code,
    Trash2,
    Play,
  } from 'lucide-svelte';

  interface Props {
    onExport?: () => void;
    onSave?: () => void;
    onPreview?: () => void;
  }

  let { onExport, onSave, onPreview }: Props = $props();

  function handleUndo() {
    historyStore.undo();
  }

  function handleRedo() {
    historyStore.redo();
  }

  function handleClear() {
    if (confirm('Are you sure you want to clear the canvas? This cannot be undone.')) {
      historyStore.saveState();
      canvasStore.clear();
    }
  }

  // Keyboard shortcuts
  function handleKeyboard(event: KeyboardEvent) {
    const isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
    const modifier = isMac ? event.metaKey : event.ctrlKey;

    if (modifier) {
      if (event.key === 'z' && !event.shiftKey) {
        event.preventDefault();
        handleUndo();
      } else if (event.key === 'z' && event.shiftKey) {
        event.preventDefault();
        handleRedo();
      } else if (event.key === 'y') {
        event.preventDefault();
        handleRedo();
      } else if (event.key === 's') {
        event.preventDefault();
        onSave?.();
      }
    } else if (event.key === 'Delete' || event.key === 'Backspace') {
      if (canvasStore.selectedId) {
        const target = event.target as HTMLElement;
        // Don't delete if typing in an input
        if (target.tagName !== 'INPUT' && target.tagName !== 'TEXTAREA') {
          event.preventDefault();
          historyStore.saveState();
          canvasStore.removeComponent(canvasStore.selectedId);
        }
      }
    }
  }

  $effect(() => {
    window.addEventListener('keydown', handleKeyboard);
    return () => window.removeEventListener('keydown', handleKeyboard);
  });
</script>

<div class="toolbar bg-white border-b border-gray-200 px-6 py-3 flex items-center justify-between">
  <div class="flex items-center gap-2">
    <h1 class="text-xl font-bold text-gray-900 mr-6">Web Builder</h1>

    <!-- History controls -->
    <div class="flex items-center gap-1 pr-4 border-r border-gray-200">
      <button
        class="toolbar-btn {historyStore.canUndo
          ? 'hover:bg-gray-100'
          : 'opacity-40 cursor-not-allowed'}"
        onclick={handleUndo}
        disabled={!historyStore.canUndo}
        title="Undo (Ctrl+Z)"
      >
        <Undo class="w-5 h-5" />
      </button>
      <button
        class="toolbar-btn {historyStore.canRedo
          ? 'hover:bg-gray-100'
          : 'opacity-40 cursor-not-allowed'}"
        onclick={handleRedo}
        disabled={!historyStore.canRedo}
        title="Redo (Ctrl+Y)"
      >
        <Redo class="w-5 h-5" />
      </button>
    </div>

    <!-- Canvas controls -->
    <div class="flex items-center gap-1">
      <button
        class="toolbar-btn hover:bg-gray-100"
        onclick={handleClear}
        title="Clear Canvas"
      >
        <Trash2 class="w-5 h-5" />
      </button>
    </div>
  </div>

  <div class="flex items-center gap-2">
    <button
      class="toolbar-btn hover:bg-gray-100"
      onclick={onPreview}
      title="Preview"
    >
      <Eye class="w-5 h-5" />
      <span class="text-sm font-medium">Preview</span>
    </button>

    <button
      class="toolbar-btn hover:bg-gray-100"
      onclick={onExport}
      title="Export Code"
    >
      <Code class="w-5 h-5" />
      <span class="text-sm font-medium">Export</span>
    </button>

    <button
      class="btn btn-primary"
      onclick={onSave}
      title="Save Project (Ctrl+S)"
    >
      <Save class="w-5 h-5" />
      <span class="text-sm font-medium">Save</span>
    </button>
  </div>
</div>

<style>
  .toolbar-btn {
    @apply flex items-center gap-2 px-3 py-2 rounded-lg transition-colors text-gray-700;
  }
</style>
