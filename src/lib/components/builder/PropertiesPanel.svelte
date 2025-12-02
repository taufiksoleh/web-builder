<script lang="ts">
  import { canvasStore } from '$lib/stores/canvas.svelte';
  import { historyStore } from '$lib/stores/history.svelte';
  import { Settings, Palette, Type as TypeIcon, Box } from 'lucide-svelte';

  type Tab = 'content' | 'styles' | 'layout';

  let activeTab = $state<Tab>('content');

  const selectedComponent = $derived(canvasStore.selectedComponent);

  function updateProp(key: string, value: any) {
    if (selectedComponent) {
      historyStore.saveState();
      canvasStore.updateProps(selectedComponent.id, { [key]: value });
    }
  }

  function updateStyle(key: string, value: string) {
    if (selectedComponent) {
      historyStore.saveState();
      canvasStore.updateStyles(selectedComponent.id, { [key]: value });
    }
  }

  function deleteComponent() {
    if (selectedComponent) {
      historyStore.saveState();
      canvasStore.removeComponent(selectedComponent.id);
    }
  }
</script>

<div class="properties-panel panel h-full flex flex-col">
  <div class="p-4 border-b border-gray-200">
    <h2 class="text-lg font-semibold text-gray-900">Properties</h2>
  </div>

  {#if !selectedComponent}
    <div class="flex-1 flex items-center justify-center p-8 text-center">
      <div class="text-gray-400">
        <Settings class="w-16 h-16 mx-auto mb-4" />
        <p class="text-sm">Select a component to edit its properties</p>
      </div>
    </div>
  {:else}
    <!-- Tabs -->
    <div class="flex border-b border-gray-200 px-4">
      <button
        class="px-4 py-3 text-sm font-medium transition-colors {activeTab === 'content'
          ? 'border-b-2 border-primary-600 text-primary-600'
          : 'text-gray-600 hover:text-gray-900'}"
        onclick={() => (activeTab = 'content')}
      >
        <div class="flex items-center gap-2">
          <TypeIcon class="w-4 h-4" />
          Content
        </div>
      </button>
      <button
        class="px-4 py-3 text-sm font-medium transition-colors {activeTab === 'styles'
          ? 'border-b-2 border-primary-600 text-primary-600'
          : 'text-gray-600 hover:text-gray-900'}"
        onclick={() => (activeTab = 'styles')}
      >
        <div class="flex items-center gap-2">
          <Palette class="w-4 h-4" />
          Styles
        </div>
      </button>
      <button
        class="px-4 py-3 text-sm font-medium transition-colors {activeTab === 'layout'
          ? 'border-b-2 border-primary-600 text-primary-600'
          : 'text-gray-600 hover:text-gray-900'}"
        onclick={() => (activeTab = 'layout')}
      >
        <div class="flex items-center gap-2">
          <Box class="w-4 h-4" />
          Layout
        </div>
      </button>
    </div>

    <!-- Tab content -->
    <div class="flex-1 overflow-y-auto p-4 space-y-4">
      <!-- Content Tab -->
      {#if activeTab === 'content'}
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Component Name</label>
            <input
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              value={selectedComponent.name}
              oninput={(e) => updateProp('name', e.currentTarget.value)}
            />
          </div>

          {#if selectedComponent.type === 'text' || selectedComponent.type === 'heading' || selectedComponent.type === 'button'}
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Text Content</label>
              <textarea
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                rows="3"
                value={selectedComponent.props.text || ''}
                oninput={(e) => updateProp('text', e.currentTarget.value)}
              ></textarea>
            </div>
          {/if}

          {#if selectedComponent.type === 'button'}
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Link (href)</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                value={selectedComponent.props.href || ''}
                oninput={(e) => updateProp('href', e.currentTarget.value)}
              />
            </div>
          {/if}

          {#if selectedComponent.type === 'image'}
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Image URL</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                value={selectedComponent.props.src || ''}
                oninput={(e) => updateProp('src', e.currentTarget.value)}
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Alt Text</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                value={selectedComponent.props.alt || ''}
                oninput={(e) => updateProp('alt', e.currentTarget.value)}
              />
            </div>
          {/if}

          {#if selectedComponent.type === 'input' || selectedComponent.type === 'textarea'}
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Placeholder</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                value={selectedComponent.props.placeholder || ''}
                oninput={(e) => updateProp('placeholder', e.currentTarget.value)}
              />
            </div>
          {/if}

          {#if selectedComponent.type === 'footer'}
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Footer Text</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                value={selectedComponent.props.text || ''}
                oninput={(e) => updateProp('text', e.currentTarget.value)}
              />
            </div>
          {/if}
        </div>
      {/if}

      <!-- Styles Tab -->
      {#if activeTab === 'styles'}
        <div class="space-y-4">
          <!-- Typography -->
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Typography</h3>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Font Size</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.fontSize || ''}
                placeholder="16px"
                oninput={(e) => updateStyle('fontSize', e.currentTarget.value)}
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Font Weight</label>
              <select
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.fontWeight || '400'}
                onchange={(e) => updateStyle('fontWeight', e.currentTarget.value)}
              >
                <option value="300">Light (300)</option>
                <option value="400">Normal (400)</option>
                <option value="500">Medium (500)</option>
                <option value="600">Semibold (600)</option>
                <option value="700">Bold (700)</option>
                <option value="800">Extra Bold (800)</option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Text Color</label>
              <div class="flex gap-2">
                <input
                  type="color"
                  class="h-10 w-14 rounded border border-gray-300"
                  value={selectedComponent.styles.color || '#000000'}
                  oninput={(e) => updateStyle('color', e.currentTarget.value)}
                />
                <input
                  type="text"
                  class="flex-1 px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.color || ''}
                  placeholder="#000000"
                  oninput={(e) => updateStyle('color', e.currentTarget.value)}
                />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Text Align</label>
              <select
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.textAlign || 'left'}
                onchange={(e) => updateStyle('textAlign', e.currentTarget.value)}
              >
                <option value="left">Left</option>
                <option value="center">Center</option>
                <option value="right">Right</option>
                <option value="justify">Justify</option>
              </select>
            </div>
          </div>

          <!-- Background -->
          <div class="space-y-3 pt-4 border-t border-gray-200">
            <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Background</h3>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Background Color</label>
              <div class="flex gap-2">
                <input
                  type="color"
                  class="h-10 w-14 rounded border border-gray-300"
                  value={selectedComponent.styles.backgroundColor || '#ffffff'}
                  oninput={(e) => updateStyle('backgroundColor', e.currentTarget.value)}
                />
                <input
                  type="text"
                  class="flex-1 px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.backgroundColor || ''}
                  placeholder="#ffffff"
                  oninput={(e) => updateStyle('backgroundColor', e.currentTarget.value)}
                />
              </div>
            </div>
          </div>

          <!-- Border -->
          <div class="space-y-3 pt-4 border-t border-gray-200">
            <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Border</h3>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Border Radius</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.borderRadius || ''}
                placeholder="8px"
                oninput={(e) => updateStyle('borderRadius', e.currentTarget.value)}
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Border Width</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.borderWidth || ''}
                placeholder="1px"
                oninput=(e) => updateStyle('borderWidth', e.currentTarget.value)}
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Border Color</label>
              <div class="flex gap-2">
                <input
                  type="color"
                  class="h-10 w-14 rounded border border-gray-300"
                  value={selectedComponent.styles.borderColor || '#000000'}
                  oninput={(e) => updateStyle('borderColor', e.currentTarget.value)}
                />
                <input
                  type="text"
                  class="flex-1 px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.borderColor || ''}
                  placeholder="#000000"
                  oninput={(e) => updateStyle('borderColor', e.currentTarget.value)}
                />
              </div>
            </div>
          </div>
        </div>
      {/if}

      <!-- Layout Tab -->
      {#if activeTab === 'layout'}
        <div class="space-y-4">
          <!-- Spacing -->
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Spacing</h3>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Padding</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.padding || ''}
                placeholder="16px"
                oninput={(e) => updateStyle('padding', e.currentTarget.value)}
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Margin</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.margin || ''}
                placeholder="0px"
                oninput={(e) => updateStyle('margin', e.currentTarget.value)}
              />
            </div>
          </div>

          <!-- Dimensions -->
          <div class="space-y-3 pt-4 border-t border-gray-200">
            <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Dimensions</h3>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Width</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.width || ''}
                placeholder="auto"
                oninput={(e) => updateStyle('width', e.currentTarget.value)}
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Height</label>
              <input
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                value={selectedComponent.styles.height || ''}
                placeholder="auto"
                oninput={(e) => updateStyle('height', e.currentTarget.value)}
              />
            </div>
          </div>

          <!-- Flexbox -->
          {#if selectedComponent.styles.display === 'flex'}
            <div class="space-y-3 pt-4 border-t border-gray-200">
              <h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide">Flexbox</h3>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Flex Direction</label>
                <select
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.flexDirection || 'row'}
                  onchange={(e) => updateStyle('flexDirection', e.currentTarget.value)}
                >
                  <option value="row">Row</option>
                  <option value="column">Column</option>
                  <option value="row-reverse">Row Reverse</option>
                  <option value="column-reverse">Column Reverse</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Justify Content</label>
                <select
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.justifyContent || 'flex-start'}
                  onchange={(e) => updateStyle('justifyContent', e.currentTarget.value)}
                >
                  <option value="flex-start">Start</option>
                  <option value="center">Center</option>
                  <option value="flex-end">End</option>
                  <option value="space-between">Space Between</option>
                  <option value="space-around">Space Around</option>
                  <option value="space-evenly">Space Evenly</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Align Items</label>
                <select
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.alignItems || 'flex-start'}
                  onchange={(e) => updateStyle('alignItems', e.currentTarget.value)}
                >
                  <option value="flex-start">Start</option>
                  <option value="center">Center</option>
                  <option value="flex-end">End</option>
                  <option value="stretch">Stretch</option>
                  <option value="baseline">Baseline</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Gap</label>
                <input
                  type="text"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  value={selectedComponent.styles.gap || ''}
                  placeholder="16px"
                  oninput={(e) => updateStyle('gap', e.currentTarget.value)}
                />
              </div>
            </div>
          {/if}
        </div>
      {/if}
    </div>

    <!-- Actions -->
    <div class="p-4 border-t border-gray-200 space-y-2">
      <button
        class="w-full px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium"
        onclick={deleteComponent}
      >
        Delete Component
      </button>
    </div>
  {/if}
</div>
