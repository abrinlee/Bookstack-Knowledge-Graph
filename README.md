# BookStack Knowledge Graph

## Context

This project implements an **interactive knowledge graph visualization** for BookStack content, intended to function as a *“second brain”* for large, organically grown documentation systems.

Rather than relying on strict hierarchies or manual tagging, the visualization dynamically extracts semantic relationships between **Books**, **Chapters**, and **Pages**, allowing users to explore content based on *conceptual proximity* rather than physical structure alone.

The result is a navigable, persistent, and filterable graph that surfaces hidden relationships across documentation sets.

---

## Goals and Design Principles

- Provide **non-linear navigation** across BookStack content
- Surface **implicit relationships** between documents
- Preserve **user spatial reasoning** through persistent node layouts
- Remain **read-only and non-destructive** to BookStack data
- Operate entirely client-side (except for API proxy access)

This is not intended to replace BookStack’s native navigation, but to **augment discovery, recall, and synthesis** across large documentation sets.

---

## Features

- Interactive force-directed knowledge graph (D3.js)
- Semantic linking via lightweight theme extraction
- Persistent node layouts using browser localStorage
- Keyword-based filtering with visual highlighting and resizable modal
- Hierarchical drill-down: Shelves → Books → Chapters → Pages (with smart fallback)
- Back/Forward navigation with breadcrumbs
- Mobile and touch-friendly UI
- Zoom and pan controls
- Read-only BookStack integration

---

## Architecture Overview

- **Client-side**: D3.js SVG visualization
- **Data source**: BookStack REST API
- **Security boundary**: PHP proxy for API token isolation
- **State persistence**: Browser localStorage (no server state)

---

## Requirements

- BookStack instance with API access enabled
- API token with read-only permissions
- PHP-capable web server
- Modern browser (Chrome, Firefox, Safari)

---

## Installation

### 1. Clone or Download the Project

```bash
git clone <repository-url>
cd Second_Mind
```

### 2. Configure Secrets

The project uses a `secrets/` directory to keep sensitive information separate from code:

```bash
# Copy configuration templates
cd secrets/
cp config.example.php config.php
cp config.example.js config.js
```

Edit `secrets/config.php` with your BookStack credentials:
- `bookstack_url`: Your BookStack instance URL (e.g., `http://192.168.0.94`)
- `api_token_id`: Your API token ID (generate in BookStack: Settings → Users → API Tokens)
- `api_token_secret`: Your API token secret

Edit `secrets/config.js` with your BookStack URL:
- `bookstackBaseUrl`: Same URL as above (used for opening pages)

Set proper permissions:
```bash
chmod 600 config.php
chmod 644 config.js
```

### 3. Deploy to Web Server

Copy files to your web-accessible directory:

```bash
# Example deployment
sudo cp bookstack-visual.html /var/www/html/
sudo cp bookstack_proxy.php /var/www/html/
sudo cp -r secrets/ /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
```

Or use the included publish script (edit paths first):
```bash
./publish.sh
```

### 4. Access the Visualization

Open your browser to `http://your-server/bookstack-visual.html`

**Security Notes:**
- Never commit `secrets/config.php` or `secrets/config.js` to version control
- API credentials are kept server-side in the PHP proxy
- The proxy ensures tokens never reach the client browser

---

## Configuration

Adjustable without code modification:

- Stop-word list for theme extraction
- Keyword color palette
- Node sizing heuristics
- Base URL normalization logic

---

## Usage

### Basic Navigation

The visualization follows BookStack's hierarchy with smart fallback:

**Hierarchy**: Shelves → Books → Chapters → Pages

1. **Starting view**: Shows shelves if available, otherwise falls back to books
2. **Click a shelf node**: Drill down to see books in that shelf
3. **Click a book node**: See chapters in that book
4. **Click a chapter node**: See all pages within that chapter
5. **Click a page node**: Opens the page in BookStack
6. **Use Back/Forward buttons**: Navigate your exploration history
7. **Breadcrumb trail**: Shows your current location (e.g., Shelves > Shelf Name > Book Name > Chapter Name)

### Node Interactions

- **Drag a node**: Move it and release to pin it in that position
- **Double-click a node**: Unpin it (returns to physics simulation)
- **"Unpin All" button**: Release all pinned nodes at once
- **Positions are saved**: When you return to a view, nodes stay where you left them

### Keyword Filter Panel Tutorial

The keyword filter helps you discover connections by highlighting shared themes between documents.

**How it works:**

1. **Click "🔍 Keywords" button** to open the filter modal
2. **The system automatically extracts keywords** from your document names and descriptions
3. **Each keyword shows:**
   - ☐ Checkbox: Enable/disable filtering for this keyword
   - 🎨 Color picker: Choose the highlight color for connections with this keyword
   - **Keyword name**: The extracted theme/concept
   - **Count badge**: How many connections share this keyword

**Sorting options:**
- **By Count**: Shows most common keywords first (useful for finding major themes)
- **A-Z**: Alphabetical order (useful for finding specific keywords)

**Using filters:**

1. **Open the modal**: Previously active keywords are already checked with their colors shown
2. **Check/uncheck keywords** you're interested in
3. **Adjust colors**: Click any color picker to customize highlight colors for that keyword
4. **Close the modal**: Click the × button or click outside the modal to apply your changes
5. **Graph updates**: Links (arrows) will now update:
   - ✅ Links containing selected keywords: Bright, colored, and thicker
   - ⚪ Links without selected keywords: Dimmed and thin
6. **Resize the modal**: Drag the bottom-right corner to see more/fewer keywords at once

**Example use cases:**
- Find all documents related to "authentication" across different books
- Discover which chapters share "database" concepts
- Identify pages that discuss "API" or "security" together
- Build a visual map of how "testing" appears throughout your docs

**Tips:**
- Select multiple keywords to see documents that cover related topics
- Use different colors for different concept categories
- The graph shows hidden relationships you might not have noticed
- Click "✕ Clear Filters" button to reset all keyword selections and show all links

### Zoom and Pan Controls

- **Mouse wheel**: Zoom in/out
- **Click and drag background**: Pan around
- **+ button**: Zoom in
- **− button**: Zoom out
- **⊙ button**: Reset zoom to default

### Collapse Controls

- Click **▲/▼ button** to collapse/expand the control panel for more graph space

---

## Security Model

- **Read-only access**: No write operations to BookStack
- **Credential isolation**: API tokens stored server-side only, never exposed to client
- **Secrets management**: Sensitive configuration separated in `secrets/` directory (git-ignored)
- **Proxy architecture**: PHP proxy acts as security boundary between client and BookStack API
- **No external services**: Fully self-hosted with no telemetry or third-party dependencies
- **File permissions**: Configuration files protected with appropriate permissions (600 for PHP, 644 for JS)

---

## Performance Notes

- Designed for hundreds of nodes per view
- Performance depends on browser and device
- Mobile devices use reduced force strength and label density

---

## Limitations

- Theme extraction is heuristic, not curated
- Relationships are probabilistic
- Not a formal ontology or taxonomy
- Stop-word list is static

---

## Roadmap

- **Progressive Keyword Filtering**: Multi-level drill-down refinement for keyword-based exploration
  - When a keyword is selected (e.g., "EMI" with 9 matching pages), the system re-analyzes only those filtered results
  - Extracts and displays a secondary set of keywords specific to the filtered subset
  - Allows users to select from these refined keywords to further narrow results (e.g., from 9 pages down to 2)
  - Supports cascading filter levels with clear visual hierarchy and breadcrumb navigation
  - Maintains result counts at each filter level for transparency
  - Provides intuitive controls to step back through filter levels or reset entirely

---

## Development

**For developers/contributors**: Development guidelines including versioning and documentation update procedures are maintained as comments at the top of the `<script>` section in `bookstack-visual.html`. Please review before making changes.

---

## Changelog

### v1.3.2 (2026-01-10)
- **Fixed default link visibility**: When no keyword filters are active, all links now display properly in default cyan color
- **Early return optimization**: Default state is now handled separately for better performance and clarity
- **Clear Filters button**: Added "✕ Clear Filters" button to quickly reset all keyword selections

### v1.3.1 (2026-01-10)
- **Fixed link label visibility**: Link labels (text showing keywords) now properly show/hide when keyword filters are applied
- **Better label filtering**: Labels are visible for matching keywords and hidden for non-matching ones

### v1.3.0 (2026-01-10)
- **Shelves support added**: Full support for BookStack shelves as the top-level navigation
- **Proper hierarchy**: Shelves → Books → Chapters → Pages with automatic fallback
- **Smart fallback logic**: If no shelves exist, shows books; if no books, shows chapters, etc.
- **Updated navigation**: Breadcrumbs and history now track full hierarchy including shelves
- **Fixed color updates**: Link colors now properly update when keyword filters are applied (uses CSS styles instead of SVG attributes)
- **Better debugging**: Enhanced console logging for filter operations

### v1.2.1 (2026-01-10)
- **Fixed keyword filter visual updates**: Links now properly change color and visibility when filters are applied
- **Fixed localStorage persistence**: Selected keywords are now saved and restored across sessions
- **Improved DOM selection**: Re-select link elements from DOM for reliable updates
- **Better debugging**: Enhanced console logging to track filter application

### v1.2.0 (2026-01-10)
- **Batch keyword filtering**: Modal now preserves current selections when opened and only applies changes when closed
- **Better UX flow**: Check/uncheck keywords and adjust colors without immediate graph updates
- **State preservation**: Opening the keyword modal shows currently active filters with their colors
- **Visual feedback**: Modal header indicates "close to apply" behavior
- **Development guidelines**: Added inline documentation for version management and README updates

### v1.1.0 (2026-01-10)
- **Resizable keyword filter modal**: Modal can now be resized by dragging the bottom-right corner
- **Flexible keyword layout**: Keywords now flow in both horizontal and vertical directions, wrapping to utilize available space
- **Improved modal sizing**: Larger default size (700px max-width) with better minimum/maximum constraints
- **Visual resize indicator**: Added subtle grip icon to indicate resizability
- **Better responsive behavior**: Modal adapts more intelligently to screen size
- **Improved sort buttons**: Clearer labels ("By Count" vs "A-Z") with better sizing
- **Comprehensive usage tutorial**: Added detailed documentation for all features including keyword filtering

### v1.0.0 (Initial Release)
- Interactive force-directed knowledge graph
- Semantic linking via lightweight theme extraction
- Persistent node layouts using browser localStorage
- Keyword-based filtering with visual highlighting
- Hierarchical drill-down: Shelves → Books → Chapters → Pages (with smart fallback)
- Back/Forward navigation with breadcrumbs
- Mobile and touch-friendly UI
- Zoom and pan controls
- Read-only BookStack integration

---

## License

MIT License
