<script lang="ts">
  import { onMount } from 'svelte';
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import { saveProject, loadCurrentProject, autoSave } from '$lib/utils/storage';
  import { Toaster, toast } from 'svelte-sonner';

  import Toolbar from '$lib/components/builder/Toolbar.svelte';
  import ComponentPalette from '$lib/components/builder/ComponentPalette.svelte';
  import Canvas from '$lib/components/builder/Canvas.svelte';
  import PropertiesPanel from '$lib/components/builder/PropertiesPanel.svelte';
  import LayersPanel from '$lib/components/builder/LayersPanel.svelte';
  import ExportModal from '$lib/components/builder/ExportModal.svelte';
  import PreviewModal from '$lib/components/builder/PreviewModal.svelte';
  import KeyboardShortcutsModal from '$lib/components/builder/KeyboardShortcutsModal.svelte';

  import '../app.css';

  let showExportModal = $state(false);
  let showPreviewModal = $state(false);
  let showShortcutsModal = $state(false);
  let lastSaved = $state<Date | null>(null);
  let isSaving = $state(false);

  // Load project on mount
  onMount(() => {
    const project = loadCurrentProject();
    if (project) {
      canvasStore.restoreState(project.canvasState);
    }
  });

  // Auto-save every 30 seconds
  let autoSaveInterval: number;
  onMount(() => {
    autoSaveInterval = window.setInterval(() => {
      if (canvasStore.components.length > 0 && !isSaving) {
        isSaving = true;
        autoSave(canvasStore.getState());
        lastSaved = new Date();
        setTimeout(() => {
          isSaving = false;
        }, 500);
      }
    }, 30000);

    return () => {
      clearInterval(autoSaveInterval);
    };
  });

  async function handleSave() {
    const projectName = prompt('Enter project name:', 'My Web Page') || 'Untitled Project';
    isSaving = true;
    try {
      saveProject(projectName, canvasStore.getState());
      lastSaved = new Date();
      toast.success('Project saved successfully!');
    } catch (error) {
      toast.error('Failed to save project');
    } finally {
      setTimeout(() => {
        isSaving = false;
      }, 500);
    }
  }

  function handleExport() {
    showExportModal = true;
  }

  function handlePreview() {
    showPreviewModal = true;
  }

  function handleShowShortcuts() {
    showShortcutsModal = true;
  }

  // Global keyboard shortcut for help
  function handleGlobalKeyboard(event: KeyboardEvent) {
    if (event.key === '?' && !event.ctrlKey && !event.metaKey) {
      const target = event.target as HTMLElement;
      // Only open shortcuts if not typing in an input
      if (target.tagName !== 'INPUT' && target.tagName !== 'TEXTAREA') {
        event.preventDefault();
        handleShowShortcuts();
      }
    }
  }

  $effect(() => {
    window.addEventListener('keydown', handleGlobalKeyboard);
    return () => window.removeEventListener('keydown', handleGlobalKeyboard);
  });
</script>

<svelte:head>
  <title>Svelte Web Builder - Drag & Drop Page Builder</title>
  <meta name="description" content="A modern drag-and-drop web builder built with Svelte 5" />
</svelte:head>

<div class="app h-screen flex flex-col overflow-hidden bg-gray-50">
  <!-- Toolbar -->
  <Toolbar onSave={handleSave} onExport={handleExport} onPreview={handlePreview} onShowShortcuts={handleShowShortcuts} />

  <!-- Main content -->
  <div class="flex-1 flex overflow-hidden">
    <!-- Left sidebar - Components & Layers -->
    <div class="w-64 flex flex-col gap-4 p-4 bg-gray-50 overflow-hidden">
      <div class="flex-1 min-h-0">
        <ComponentPalette />
      </div>
      <div class="flex-1 min-h-0">
        <LayersPanel />
      </div>
    </div>

    <!-- Center - Canvas -->
    <div class="flex-1 min-w-0">
      <Canvas />
    </div>

    <!-- Right sidebar - Properties -->
    <div class="w-80 bg-gray-50 p-4 overflow-hidden">
      <PropertiesPanel />
    </div>
  </div>

  <!-- Status bar -->
  <div class="bg-white border-t border-gray-200 px-6 py-2 flex items-center justify-between text-sm text-gray-600">
    <div class="flex items-center gap-4">
      <span>{canvasStore.components.length} components</span>
      {#if canvasStore.selectedComponent}
        <span class="text-primary-600 font-medium">
          Selected: {canvasStore.selectedComponent.name}
        </span>
      {/if}
    </div>
    <div class="flex items-center gap-2">
      {#if isSaving}
        <span class="flex items-center gap-2 text-blue-600">
          <svg class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          Saving...
        </span>
      {:else if lastSaved}
        <span>Last saved: {lastSaved.toLocaleTimeString()}</span>
      {:else}
        <span>Not saved</span>
      {/if}
    </div>
  </div>
</div>

<!-- Modals -->
<ExportModal bind:open={showExportModal} onClose={() => (showExportModal = false)} />
<PreviewModal bind:open={showPreviewModal} onClose={() => (showPreviewModal = false)} />
<KeyboardShortcutsModal bind:open={showShortcutsModal} onClose={() => (showShortcutsModal = false)} />

<!-- Toast notifications -->
<Toaster richColors position="bottom-right" />
