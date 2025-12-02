import type { Component, CanvasState, Breakpoint } from '$lib/types';
import { nanoid } from 'nanoid';

// Canvas state with Svelte 5 runes
class CanvasStore {
  components = $state<Component[]>([]);
  selectedId = $state<string | null>(null);
  hoveredId = $state<string | null>(null);
  breakpoint = $state<Breakpoint>('desktop');

  // Get selected component
  get selectedComponent(): Component | null {
    if (!this.selectedId) return null;
    return this.findComponent(this.selectedId);
  }

  // Find component by ID (recursive)
  findComponent(id: string, components: Component[] = this.components): Component | null {
    for (const component of components) {
      if (component.id === id) return component;
      const found = this.findComponent(id, component.children);
      if (found) return found;
    }
    return null;
  }

  // Add component to canvas
  addComponent(type: Component['type'], parentId: string | null = null) {
    const newComponent: Component = {
      id: nanoid(),
      type,
      name: `${type}-${Date.now()}`,
      children: [],
      parent: parentId,
      styles: this.getDefaultStyles(type),
      props: this.getDefaultProps(type),
      locked: false,
      hidden: false,
    };

    if (parentId) {
      const parent = this.findComponent(parentId);
      if (parent) {
        parent.children.push(newComponent);
      }
    } else {
      this.components.push(newComponent);
    }

    this.selectedId = newComponent.id;
    return newComponent;
  }

  // Remove component
  removeComponent(id: string) {
    const removeFromArray = (components: Component[]): Component[] => {
      return components.filter(comp => {
        if (comp.id === id) return false;
        comp.children = removeFromArray(comp.children);
        return true;
      });
    };

    this.components = removeFromArray(this.components);
    if (this.selectedId === id) {
      this.selectedId = null;
    }
  }

  // Update component styles
  updateStyles(id: string, styles: Partial<Component['styles']>) {
    const component = this.findComponent(id);
    if (component) {
      component.styles = { ...component.styles, ...styles };
    }
  }

  // Update component props
  updateProps(id: string, props: Partial<Component['props']>) {
    const component = this.findComponent(id);
    if (component) {
      component.props = { ...component.props, ...props };
    }
  }

  // Select component
  selectComponent(id: string | null) {
    this.selectedId = id;
  }

  // Set hover state
  setHovered(id: string | null) {
    this.hoveredId = id;
  }

  // Toggle component lock
  toggleLock(id: string) {
    const component = this.findComponent(id);
    if (component) {
      component.locked = !component.locked;
    }
  }

  // Toggle component visibility
  toggleVisibility(id: string) {
    const component = this.findComponent(id);
    if (component) {
      component.hidden = !component.hidden;
    }
  }

  // Set breakpoint
  setBreakpoint(breakpoint: Breakpoint) {
    this.breakpoint = breakpoint;
  }

  // Get current state (for history)
  getState(): CanvasState {
    return {
      components: JSON.parse(JSON.stringify(this.components)),
      selectedId: this.selectedId,
      hoveredId: this.hoveredId,
    };
  }

  // Restore state (for history)
  restoreState(state: CanvasState) {
    this.components = JSON.parse(JSON.stringify(state.components));
    this.selectedId = state.selectedId;
    this.hoveredId = state.hoveredId;
  }

  // Clear canvas
  clear() {
    this.components = [];
    this.selectedId = null;
    this.hoveredId = null;
  }

  // Default styles for each component type
  private getDefaultStyles(type: Component['type']): Component['styles'] {
    const baseStyles = {
      padding: '16px',
      margin: '0px',
    };

    const typeStyles: Record<Component['type'], Partial<Component['styles']>> = {
      container: {
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
        backgroundColor: '#f3f4f6',
        borderRadius: '8px',
        minHeight: '200px',
        width: '100%',
      },
      row: {
        display: 'flex',
        flexDirection: 'row',
        gap: '16px',
        width: '100%',
      },
      column: {
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
        flex: '1',
      },
      text: {
        fontSize: '16px',
        lineHeight: '1.5',
        color: '#374151',
      },
      heading: {
        fontSize: '32px',
        fontWeight: '700',
        lineHeight: '1.2',
        color: '#111827',
      },
      button: {
        backgroundColor: '#3b82f6',
        color: '#ffffff',
        padding: '12px 24px',
        borderRadius: '8px',
        fontSize: '16px',
        fontWeight: '600',
        display: 'inline-block',
      },
      image: {
        width: '100%',
        height: 'auto',
        borderRadius: '8px',
      },
      input: {
        borderWidth: '1px',
        borderColor: '#d1d5db',
        borderRadius: '6px',
        padding: '10px 12px',
        fontSize: '16px',
        width: '100%',
      },
      textarea: {
        borderWidth: '1px',
        borderColor: '#d1d5db',
        borderRadius: '6px',
        padding: '10px 12px',
        fontSize: '16px',
        width: '100%',
        minHeight: '120px',
      },
      card: {
        backgroundColor: '#ffffff',
        borderRadius: '12px',
        padding: '24px',
        boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1)',
      },
      navbar: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: '#ffffff',
        padding: '16px 32px',
        boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1)',
      },
      footer: {
        backgroundColor: '#1f2937',
        color: '#ffffff',
        padding: '48px 32px',
        textAlign: 'center',
      },
      hero: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f9fafb',
        padding: '80px 32px',
        textAlign: 'center',
      },
    };

    return { ...baseStyles, ...typeStyles[type] };
  }

  // Default props for each component type
  private getDefaultProps(type: Component['type']): Component['props'] {
    const propsMap: Record<Component['type'], Component['props']> = {
      container: {},
      row: {},
      column: {},
      text: { text: 'Enter your text here' },
      heading: { text: 'Heading Text' },
      button: { text: 'Button', href: '#' },
      image: {
        src: 'https://via.placeholder.com/800x600',
        alt: 'Placeholder image',
      },
      input: { placeholder: 'Enter text...', type: 'text' },
      textarea: { placeholder: 'Enter your message...', rows: 4 },
      card: {},
      navbar: {},
      footer: { text: '© 2024 Your Company. All rights reserved.' },
      hero: {},
    };

    return propsMap[type];
  }
}

export const canvasStore = new CanvasStore();
