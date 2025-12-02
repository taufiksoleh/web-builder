<script lang="ts">
  import Modal from '$lib/components/ui/Modal.svelte';
  import { Keyboard } from 'lucide-svelte';

  interface Props {
    open?: boolean;
    onClose: () => void;
  }

  let { open = $bindable(false), onClose }: Props = $props();

  const shortcuts = [
    {
      category: 'Editing',
      items: [
        { keys: ['Ctrl/Cmd', 'Z'], description: 'Undo last action' },
        { keys: ['Ctrl/Cmd', 'Shift', 'Z'], description: 'Redo last action' },
        { keys: ['Ctrl/Cmd', 'Y'], description: 'Redo last action' },
        { keys: ['Ctrl/Cmd', 'D'], description: 'Duplicate selected component' },
        { keys: ['Delete'], description: 'Delete selected component' },
        { keys: ['Backspace'], description: 'Delete selected component' },
      ],
    },
    {
      category: 'Project',
      items: [
        { keys: ['Ctrl/Cmd', 'S'], description: 'Save project' },
      ],
    },
    {
      category: 'Help',
      items: [
        { keys: ['?'], description: 'Show keyboard shortcuts' },
      ],
    },
  ];
</script>

<Modal {open} title="Keyboard Shortcuts" {onClose}>
  <div class="space-y-6">
    {#each shortcuts as section}
      <div>
        <h3 class="text-lg font-semibold text-gray-900 mb-3">{section.category}</h3>
        <div class="space-y-2">
          {#each section.items as shortcut}
            <div class="flex items-center justify-between py-2 px-3 rounded-lg hover:bg-gray-50">
              <span class="text-sm text-gray-700">{shortcut.description}</span>
              <div class="flex items-center gap-1">
                {#each shortcut.keys as key}
                  <kbd
                    class="px-2 py-1 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-300 rounded shadow-sm"
                  >
                    {key}
                  </kbd>
                  {#if shortcut.keys.indexOf(key) < shortcut.keys.length - 1}
                    <span class="text-gray-400">+</span>
                  {/if}
                {/each}
              </div>
            </div>
          {/each}
        </div>
      </div>
    {/each}

    <div class="pt-4 border-t border-gray-200">
      <div class="flex items-start gap-3 p-4 bg-blue-50 rounded-lg">
        <Keyboard class="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
        <div class="text-sm text-blue-900">
          <p class="font-medium mb-1">Pro Tip</p>
          <p class="text-blue-800">
            Use keyboard shortcuts to work faster and more efficiently. Press
            <kbd
              class="px-2 py-0.5 text-xs font-semibold bg-blue-100 border border-blue-300 rounded mx-1"
            >
              ?
            </kbd>
            anytime to see this list.
          </p>
        </div>
      </div>
    </div>
  </div>
</Modal>
