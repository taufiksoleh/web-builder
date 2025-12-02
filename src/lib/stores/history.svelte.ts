import type { CanvasState } from '$lib/types';
import { canvasStore } from './canvas.svelte';

// History store for undo/redo functionality
class HistoryStore {
  past = $state<CanvasState[]>([]);
  future = $state<CanvasState[]>([]);
  private maxHistory = 50;

  // Check if can undo
  get canUndo(): boolean {
    return this.past.length > 0;
  }

  // Check if can redo
  get canRedo(): boolean {
    return this.future.length > 0;
  }

  // Save current state to history
  saveState() {
    const currentState = canvasStore.getState();

    // Add current state to past
    this.past.push(currentState);

    // Limit history size
    if (this.past.length > this.maxHistory) {
      this.past.shift();
    }

    // Clear future when new action is performed
    this.future = [];
  }

  // Undo last action
  undo() {
    if (!this.canUndo) return;

    // Save current state to future
    const currentState = canvasStore.getState();
    this.future.unshift(currentState);

    // Restore previous state
    const previousState = this.past.pop()!;
    canvasStore.restoreState(previousState);
  }

  // Redo last undone action
  redo() {
    if (!this.canRedo) return;

    // Save current state to past
    const currentState = canvasStore.getState();
    this.past.push(currentState);

    // Restore next state
    const nextState = this.future.shift()!;
    canvasStore.restoreState(nextState);
  }

  // Clear history
  clear() {
    this.past = [];
    this.future = [];
  }
}

export const historyStore = new HistoryStore();
