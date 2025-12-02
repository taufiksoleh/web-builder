<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import type { Component } from '$lib/types';
  import { Monitor, Tablet, Smartphone } from 'lucide-svelte';
  import ComponentRenderer from './ComponentRenderer.svelte';

  const breakpoints = {
    desktop: { label: 'Desktop', icon: Monitor, width: '100%' },
    tablet: { label: 'Tablet', icon: Tablet, width: '768px' },
    mobile: { label: 'Mobile', icon: Smartphone, width: '375px' },
  };

  function handleDrop(event: DragEvent) {
    event.preventDefault();
    const componentType = event.dataTransfer?.getData('componentType');
    if (componentType) {
      historyStore.saveState();
      canvasStore.addComponent(componentType as Component['type']);
    }
  }

  function handleDragOver(event: DragEvent) {
    event.preventDefault();
    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = 'copy';
    }
  }

  function handleCanvasClick(event: MouseEvent) {
    // Deselect if clicking on canvas background
    if (event.target === event.currentTarget) {
      canvasStore.selectComponent(null);
    }
  }
</script>

<div class="canvas-container h-full flex flex-col bg-gray-100">
  <!-- Breakpoint selector -->
  <div class="toolbar flex items-center justify-center gap-2 px-4 py-3 bg-white border-b border-gray-200">
    {#each Object.entries(breakpoints) as [key, { label, icon }]}
      <button
        class="flex items-center gap-2 px-4 py-2 rounded-lg transition-colors {canvasStore.breakpoint ===
        key
          ? 'bg-primary-600 text-white'
          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
        onclick={() => canvasStore.setBreakpoint(key as any)}
      >
        <svelte:component this={icon} class="w-4 h-4" />
        <span class="text-sm font-medium">{label}</span>
      </button>
    {/each}
  </div>

  <!-- Canvas area -->
  <div class="flex-1 overflow-auto p-8">
    <div
      class="canvas-viewport mx-auto bg-white shadow-lg rounded-lg min-h-[600px] transition-all duration-300"
      style="width: {breakpoints[canvasStore.breakpoint].width};"
      ondrop={handleDrop}
      ondragover={handleDragOver}
      onclick={handleCanvasClick}
      role="region"
      aria-label="Canvas"
    >
      {#if canvasStore.components.length === 0}
        <div
          class="flex flex-col items-center justify-center h-full text-gray-400 p-12 text-center"
        >
          <svg
            class="w-24 h-24 mb-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="1.5"
              d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"
            />
          </svg>
          <h3 class="text-xl font-semibold mb-2">Start Building</h3>
          <p class="text-sm max-w-md">
            Drag components from the left panel or click on them to add to your canvas
          </p>
        </div>
      {:else}
        <div class="components-wrapper p-4">
          {#each canvasStore.components as component (component.id)}
            <ComponentRenderer {component} />
          {/each}
        </div>
      {/if}
    </div>
  </div>
</div>

<style>
  .canvas-viewport {
    position: relative;
  }
</style>
