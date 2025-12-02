<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import type { ComponentType } from '$lib/types';
  import {
    Box,
    Type,
    Heading1,
    MousePointer,
    Image,
    Square,
    AlignJustify,
    FormInput,
    CreditCard,
    Menu,
    Copyright,
    Columns2,
    Rows3,
  } from 'lucide-svelte';

  interface PaletteItem {
    type: ComponentType;
    label: string;
    icon: any;
    category: 'layout' | 'content' | 'forms' | 'sections';
  }

  const components: PaletteItem[] = [
    // Layout
    { type: 'container', label: 'Container', icon: Box, category: 'layout' },
    { type: 'row', label: 'Row', icon: Rows3, category: 'layout' },
    { type: 'column', label: 'Column', icon: Columns2, category: 'layout' },

    // Content
    { type: 'text', label: 'Text', icon: Type, category: 'content' },
    { type: 'heading', label: 'Heading', icon: Heading1, category: 'content' },
    { type: 'button', label: 'Button', icon: MousePointer, category: 'content' },
    { type: 'image', label: 'Image', icon: Image, category: 'content' },

    // Forms
    { type: 'input', label: 'Input', icon: FormInput, category: 'forms' },
    { type: 'textarea', label: 'Textarea', icon: AlignJustify, category: 'forms' },

    // Sections
    { type: 'card', label: 'Card', icon: CreditCard, category: 'sections' },
    { type: 'navbar', label: 'Navbar', icon: Menu, category: 'sections' },
    { type: 'hero', label: 'Hero', icon: Square, category: 'sections' },
    { type: 'footer', label: 'Footer', icon: Copyright, category: 'sections' },
  ];

  const categories = {
    layout: 'Layout',
    content: 'Content',
    forms: 'Forms',
    sections: 'Sections',
  };

  let activeCategory = $state<keyof typeof categories | 'all'>('all');

  const filteredComponents = $derived(
    activeCategory === 'all'
      ? components
      : components.filter((c) => c.category === activeCategory)
  );

  function addComponent(type: ComponentType) {
    historyStore.saveState();
    canvasStore.addComponent(type);
  }

  function handleDragStart(event: DragEvent, type: ComponentType) {
    if (event.dataTransfer) {
      event.dataTransfer.effectAllowed = 'copy';
      event.dataTransfer.setData('componentType', type);
    }
  }
</script>

<div class="component-palette panel h-full flex flex-col">
  <div class="p-4 border-b border-gray-200">
    <h2 class="text-lg font-semibold text-gray-900 mb-3">Components</h2>

    <!-- Category filters -->
    <div class="flex gap-2 flex-wrap">
      <button
        class="px-3 py-1 text-sm rounded-lg transition-colors {activeCategory === 'all'
          ? 'bg-primary-600 text-white'
          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
        onclick={() => (activeCategory = 'all')}
      >
        All
      </button>
      {#each Object.entries(categories) as [key, label]}
        <button
          class="px-3 py-1 text-sm rounded-lg transition-colors {activeCategory === key
            ? 'bg-primary-600 text-white'
            : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
          onclick={() => (activeCategory = key as keyof typeof categories)}
        >
          {label}
        </button>
      {/each}
    </div>
  </div>

  <!-- Component grid -->
  <div class="flex-1 overflow-y-auto p-4">
    <div class="grid grid-cols-2 gap-3">
      {#each filteredComponents as component}
        <button
          class="component-item flex flex-col items-center gap-2 p-4 rounded-lg border-2 border-gray-200 hover:border-primary-500 hover:bg-primary-50 transition-all cursor-move"
          draggable="true"
          ondragstart={(e) => handleDragStart(e, component.type)}
          onclick={() => addComponent(component.type)}
        >
          <svelte:component this={component.icon} class="w-6 h-6 text-gray-700" />
          <span class="text-sm font-medium text-gray-900">{component.label}</span>
        </button>
      {/each}
    </div>
  </div>

  <div class="p-4 border-t border-gray-200 bg-gray-50">
    <p class="text-xs text-gray-600">
      <strong>Tip:</strong> Drag components to the canvas or click to add
    </p>
  </div>
</div>

<style>
  .component-item:active {
    cursor: grabbing;
  }
</style>
