import type { Component } from '$lib/types';

export function generateHTML(components: Component[]): string {
  function renderComponent(component: Component): string {
    const styles = generateInlineStyles(component.styles);
    const styleAttr = styles ? ` style="${styles}"` : '';

    switch (component.type) {
      case 'text':
        return `<p${styleAttr}>${component.props.text || 'Text'}</p>`;

      case 'heading':
        return `<h1${styleAttr}>${component.props.text || 'Heading'}</h1>`;

      case 'button':
        return `<button${styleAttr}>${component.props.text || 'Button'}</button>`;

      case 'image':
        return `<img src="${component.props.src || ''}" alt="${component.props.alt || ''}"${styleAttr} />`;

      case 'input':
        return `<input type="${component.props.type || 'text'}" placeholder="${component.props.placeholder || ''}"${styleAttr} />`;

      case 'textarea':
        return `<textarea placeholder="${component.props.placeholder || ''}" rows="${component.props.rows || 4}"${styleAttr}></textarea>`;

      case 'container':
      case 'card':
      case 'row':
      case 'column':
        const children = component.children.map(renderComponent).join('\n    ');
        return `<div${styleAttr}>\n    ${children || ''}\n  </div>`;

      case 'navbar':
        const navChildren = component.children.map(renderComponent).join('\n    ');
        return `<nav${styleAttr}>\n    ${navChildren || ''}\n  </nav>`;

      case 'hero':
        const heroChildren = component.children.map(renderComponent).join('\n    ');
        return `<section${styleAttr}>\n    ${heroChildren || ''}\n  </section>`;

      case 'footer':
        const footerChildren = component.children.map(renderComponent).join('\n    ');
        const footerText = component.props.text ? `\n    <p>${component.props.text}</p>` : '';
        return `<footer${styleAttr}>${footerChildren}${footerText}\n  </footer>`;

      default:
        return `<div${styleAttr}></div>`;
    }
  }

  const componentsHTML = components.map(renderComponent).join('\n  ');

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generated Page</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      line-height: 1.5;
    }
  </style>
</head>
<body>
  ${componentsHTML}
</body>
</html>`;
}

export function generateCSS(components: Component[]): string {
  let css = '';
  let classCounter = 0;

  function generateClassForComponent(component: Component): string {
    const className = `component-${classCounter++}`;
    const styles = Object.entries(component.styles)
      .map(([key, value]) => {
        const cssKey = key.replace(/([A-Z])/g, '-$1').toLowerCase();
        return `  ${cssKey}: ${value};`;
      })
      .join('\n');

    css += `.${className} {\n${styles}\n}\n\n`;

    component.children.forEach(generateClassForComponent);

    return className;
  }

  components.forEach(generateClassForComponent);

  return css;
}

function generateInlineStyles(styles: Component['styles']): string {
  return Object.entries(styles)
    .map(([key, value]) => {
      const cssKey = key.replace(/([A-Z])/g, '-$1').toLowerCase();
      return `${cssKey}: ${value}`;
    })
    .join('; ');
}

export function downloadFile(content: string, filename: string, type: string = 'text/html') {
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
