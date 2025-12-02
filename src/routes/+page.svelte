<script lang="ts">
  import { onMount } from 'svelte';
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import { saveProject, loadCurrentProject, autoSave } from '$lib/utils/storage';

  import Toolbar from '$lib/components/builder/Toolbar.svelte';
  import ComponentPalette from '$lib/components/builder/ComponentPalette.svelte';
  import Canvas from '$lib/components/builder/Canvas.svelte';
  import PropertiesPanel from '$lib/components/builder/PropertiesPanel.svelte';
  import LayersPanel from '$lib/components/builder/LayersPanel.svelte';
  import ExportModal from '$lib/components/builder/ExportModal.svelte';
  import PreviewModal from '$lib/components/builder/PreviewModal.svelte';

  import '../app.css';

  let showExportModal = $state(false);
  let showPreviewModal = $state(false);
  let lastSaved = $state<Date | null>(null);

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
      if (canvasStore.components.length > 0) {
        autoSave(canvasStore.getState());
        lastSaved = new Date();
      }
    }, 30000);

    return () => {
      clearInterval(autoSaveInterval);
    };
  });

  function handleSave() {
    const projectName = prompt('Enter project name:', 'My Web Page') || 'Untitled Project';
    saveProject(projectName, canvasStore.getState());
    lastSaved = new Date();
    alert('Project saved successfully!');
  }

  function handleExport() {
    showExportModal = true;
  }

  function handlePreview() {
    showPreviewModal = true;
  }
</script>

<svelte:head>
  <title>Svelte Web Builder - Drag & Drop Page Builder</title>
  <meta name="description" content="A modern drag-and-drop web builder built with Svelte 5" />
</svelte:head>

<div class="app h-screen flex flex-col overflow-hidden bg-gray-50">
  <!-- Toolbar -->
  <Toolbar onSave={handleSave} onExport={handleExport} onPreview={handlePreview} />

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
    <div>
      {#if lastSaved}
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
