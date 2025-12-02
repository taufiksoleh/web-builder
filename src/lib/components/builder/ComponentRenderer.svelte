<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import type { Component } from '$lib/types';

  interface Props {
    component: Component;
  }

  let { component }: Props = $props();

  const isSelected = $derived(canvasStore.selectedId === component.id);
  const isHovered = $derived(canvasStore.hoveredId === component.id);

  function handleClick(event: MouseEvent) {
    event.stopPropagation();
    if (!component.locked) {
      canvasStore.selectComponent(component.id);
    }
  }

  function handleMouseEnter() {
    canvasStore.setHovered(component.id);
  }

  function handleMouseLeave() {
    canvasStore.setHovered(null);
  }

  function getInlineStyles(styles: Component['styles']): string {
    return Object.entries(styles)
      .map(([key, value]) => {
        const cssKey = key.replace(/([A-Z])/g, '-$1').toLowerCase();
        return `${cssKey}: ${value}`;
      })
      .join('; ');
  }

  function handleDrop(event: DragEvent) {
    event.stopPropagation();
    event.preventDefault();

    const componentType = event.dataTransfer?.getData('componentType');
    if (componentType && !component.locked) {
      canvasStore.addComponent(componentType as Component['type'], component.id);
    }
  }

  function handleDragOver(event: DragEvent) {
    event.stopPropagation();
    event.preventDefault();
    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = 'copy';
    }
  }
</script>

{#if !component.hidden}
  <div
    class="component-wrapper relative {isSelected
      ? 'ring-2 ring-primary-500 ring-offset-2'
      : ''} {isHovered && !isSelected ? 'ring-1 ring-primary-300' : ''} {component.locked
      ? 'opacity-60'
      : ''}"
    onclick={handleClick}
    onmouseenter={handleMouseEnter}
    onmouseleave={handleMouseLeave}
    ondrop={handleDrop}
    ondragover={handleDragOver}
    role="button"
    tabindex="0"
    aria-label="{component.type} component"
  >
    <!-- Selection indicator -->
    {#if isSelected}
      <div
        class="absolute -top-6 left-0 px-2 py-1 bg-primary-600 text-white text-xs font-medium rounded-t z-10"
      >
        {component.name}
      </div>
    {/if}

    <!-- Component content -->
    <div style={getInlineStyles(component.styles)} data-component-id={component.id}>
      {#if component.type === 'text'}
        <p>{component.props.text || 'Text'}</p>
      {:else if component.type === 'heading'}
        <h1>{component.props.text || 'Heading'}</h1>
      {:else if component.type === 'button'}
        <button type="button">{component.props.text || 'Button'}</button>
      {:else if component.type === 'image'}
        <img src={component.props.src} alt={component.props.alt || ''} />
      {:else if component.type === 'input'}
        <input
          type={component.props.type || 'text'}
          placeholder={component.props.placeholder || ''}
        />
      {:else if component.type === 'textarea'}
        <textarea
          placeholder={component.props.placeholder || ''}
          rows={component.props.rows || 4}
        ></textarea>
      {:else if component.type === 'container' || component.type === 'card' || component.type === 'navbar' || component.type === 'hero' || component.type === 'footer' || component.type === 'row' || component.type === 'column'}
        {#if component.children.length === 0}
          <div class="min-h-[100px] flex items-center justify-center text-gray-400 text-sm">
            Drop components here
          </div>
        {:else}
          {#each component.children as child (child.id)}
            <svelte:self component={child} />
          {/each}
        {/if}

        {#if component.type === 'footer' && component.props.text}
          <p>{component.props.text}</p>
        {/if}
      {/if}
    </div>
  </div>
{/if}

<style>
  .component-wrapper {
    transition: all 0.15s ease;
  }

  .component-wrapper:hover {
    cursor: pointer;
  }
</style>
