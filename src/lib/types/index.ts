// Component types that can be added to the canvas
export type ComponentType =
  | 'container'
  | 'text'
  | 'heading'
  | 'button'
  | 'image'
  | 'input'
  | 'textarea'
  | 'card'
  | 'navbar'
  | 'footer'
  | 'hero'
  | 'column'
  | 'row';

// Style properties for components
export interface ComponentStyles {
  // Layout
  width?: string;
  height?: string;
  padding?: string;
  margin?: string;
  display?: string;
  flexDirection?: string;
  justifyContent?: string;
  alignItems?: string;
  gap?: string;

  // Typography
  fontSize?: string;
  fontWeight?: string;
  lineHeight?: string;
  textAlign?: string;
  color?: string;

  // Background
  backgroundColor?: string;
  backgroundImage?: string;

  // Border
  borderRadius?: string;
  borderWidth?: string;
  borderColor?: string;
  borderStyle?: string;

  // Effects
  boxShadow?: string;
  opacity?: string;

  // Position
  position?: string;
  top?: string;
  left?: string;
  right?: string;
  bottom?: string;
  zIndex?: number;

  // Custom CSS
  [key: string]: string | number | undefined;
}

// Component data structure
export interface Component {
  id: string;
  type: ComponentType;
  name: string;
  children: Component[];
  parent: string | null;
  styles: ComponentStyles;
  props: {
    text?: string;
    src?: string;
    alt?: string;
    placeholder?: string;
    href?: string;
    [key: string]: any;
  };
  locked: boolean;
  hidden: boolean;
}

// Canvas state
export interface CanvasState {
  components: Component[];
  selectedId: string | null;
  hoveredId: string | null;
}

// History state for undo/redo
export interface HistoryState {
  past: CanvasState[];
  present: CanvasState;
  future: CanvasState[];
}

// Responsive breakpoints
export type Breakpoint = 'mobile' | 'tablet' | 'desktop';

// Project metadata
export interface Project {
  id: string;
  name: string;
  createdAt: number;
  updatedAt: number;
  canvasState: CanvasState;
}
