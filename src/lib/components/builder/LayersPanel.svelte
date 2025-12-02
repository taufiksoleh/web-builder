<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import type { Component } from '$lib/types';
  import { Layers, Eye, EyeOff, Lock, Unlock, ChevronRight, ChevronDown } from 'lucide-svelte';

  let expandedIds = $state<Set<string>>(new Set());

  function toggleExpanded(id: string) {
    if (expandedIds.has(id)) {
      expandedIds.delete(id);
    } else {
      expandedIds.add(id);
    }
    expandedIds = expandedIds; // Trigger reactivity
  }

  function selectComponent(id: string) {
    canvasStore.selectComponent(id);
  }

  function toggleVisibility(id: string, event: MouseEvent) {
    event.stopPropagation();
    historyStore.saveState();
    canvasStore.toggleVisibility(id);
  }

  function toggleLock(id: string, event: MouseEvent) {
    event.stopPropagation();
    historyStore.saveState();
    canvasStore.toggleLock(id);
  }

  function renderLayerTree(components: Component[], depth = 0): any {
    return components.map((component) => ({
      component,
      depth,
      children: component.children.length > 0 ? renderLayerTree(component.children, depth + 1) : [],
    }));
  }

  const layerTree = $derived(renderLayerTree(canvasStore.components));

  function flattenTree(tree: any[]): any[] {
    let result: any[] = [];
    for (const item of tree) {
      result.push(item);
      if (item.children.length > 0 && expandedIds.has(item.component.id)) {
        result = result.concat(flattenTree(item.children));
      }
    }
    return result;
  }

  const flatLayers = $derived(flattenTree(layerTree));
</script>

<div class="layers-panel panel h-full flex flex-col">
  <div class="p-4 border-b border-gray-200">
    <div class="flex items-center gap-2">
      <Layers class="w-5 h-5 text-gray-700" />
      <h2 class="text-lg font-semibold text-gray-900">Layers</h2>
    </div>
  </div>

  <div class="flex-1 overflow-y-auto">
    {#if canvasStore.components.length === 0}
      <div class="flex flex-col items-center justify-center h-full p-8 text-center text-gray-400">
        <Layers class="w-16 h-16 mb-3" />
        <p class="text-sm">No components yet</p>
      </div>
    {:else}
      <div class="py-2">
        {#each flatLayers as { component, depth }}
          {@const isSelected = canvasStore.selectedId === component.id}
          {@const hasChildren = component.children.length > 0}
          {@const isExpanded = expandedIds.has(component.id)}

          <div
            class="layer-item w-full flex items-center gap-2 px-3 py-2 hover:bg-gray-100 transition-colors cursor-pointer {isSelected
              ? 'bg-primary-50 border-l-4 border-primary-600'
              : 'border-l-4 border-transparent'}"
            style="padding-left: {depth * 20 + 12}px"
            onclick={() => selectComponent(component.id)}
            role="button"
            tabindex="0"
            onkeydown={(e) => e.key === 'Enter' && selectComponent(component.id)}
          >
            <!-- Expand/collapse button -->
            <div class="w-4 h-4 flex items-center justify-center flex-shrink-0">
              {#if hasChildren}
                <button
                  class="hover:bg-gray-200 rounded"
                  onclick={(e) => {
                    e.stopPropagation();
                    toggleExpanded(component.id);
                  }}
                  aria-label={isExpanded ? 'Collapse' : 'Expand'}
                >
                  {#if isExpanded}
                    <ChevronDown class="w-4 h-4 text-gray-600" />
                  {:else}
                    <ChevronRight class="w-4 h-4 text-gray-600" />
                  {/if}
                </button>
              {/if}
            </div>

            <!-- Component info -->
            <div class="flex-1 flex items-center gap-2 min-w-0">
              <span
                class="text-sm font-medium truncate {component.hidden
                  ? 'text-gray-400 line-through'
                  : isSelected
                    ? 'text-primary-700'
                    : 'text-gray-900'}"
              >
                {component.name}
              </span>
              <span class="text-xs text-gray-500 flex-shrink-0">({component.type})</span>
            </div>

            <!-- Actions -->
            <div class="flex items-center gap-1 flex-shrink-0">
              <button
                class="p-1 hover:bg-gray-200 rounded transition-colors"
                onclick={(e) => {
                  e.stopPropagation();
                  toggleVisibility(component.id, e);
                }}
                title={component.hidden ? 'Show' : 'Hide'}
                aria-label={component.hidden ? 'Show' : 'Hide'}
              >
                {#if component.hidden}
                  <EyeOff class="w-4 h-4 text-gray-500" />
                {:else}
                  <Eye class="w-4 h-4 text-gray-600" />
                {/if}
              </button>

              <button
                class="p-1 hover:bg-gray-200 rounded transition-colors"
                onclick={(e) => {
                  e.stopPropagation();
                  toggleLock(component.id, e);
                }}
                title={component.locked ? 'Unlock' : 'Lock'}
                aria-label={component.locked ? 'Unlock' : 'Lock'}
              >
                {#if component.locked}
                  <Lock class="w-4 h-4 text-gray-500" />
                {:else}
                  <Unlock class="w-4 h-4 text-gray-600" />
                {/if}
              </button>
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>

  <div class="p-4 border-t border-gray-200 bg-gray-50">
    <p class="text-xs text-gray-600">
      <strong>Tip:</strong> Click to select, use eye/lock icons to toggle visibility and locking
    </p>
  </div>
</div>

<style>
  .layer-item {
    text-align: left;
  }
</style>
