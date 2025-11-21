import { ref, computed } from "vue";

export const useCanvas = () => {
  // Canvas State
  const zoom = ref(1);
  const pan = ref({ x: 0, y: 0 });
  const isPanning = ref(false);
  const lastMousePos = ref({ x: 0, y: 0 });

  // Selection State
  const selectedIds = ref(new Set<string>());
  const dragging = ref(false);
  const resizing = ref(false);

  // Grid Settings
  const gridSize = ref(20);
  const showGrid = ref(true);
  const snapToGrid = ref(true);

  // History
  const history = ref([]);
  const historyIndex = ref(-1);

  // Snap helper
  const snap = (value: number) => {
    if (!snapToGrid.value) return value;
    return Math.round(value / gridSize.value) * gridSize.value;
  };

  // Canvas Navigation
  const startPan = (e: MouseEvent) => {
    if (e.button === 1 || (e.button === 0 && (e as any).spaceKey)) {
      // Middle click or Space+Left
      isPanning.value = true;
      lastMousePos.value = { x: e.clientX, y: e.clientY };
      e.preventDefault();
    }
  };

  const handlePan = (e: MouseEvent) => {
    if (!isPanning.value) return;
    const dx = e.clientX - lastMousePos.value.x;
    const dy = e.clientY - lastMousePos.value.y;
    pan.value.x += dx;
    pan.value.y += dy;
    lastMousePos.value = { x: e.clientX, y: e.clientY };
  };

  const stopPan = () => {
    isPanning.value = false;
  };

  const handleWheel = (e: WheelEvent) => {
    if (e.ctrlKey || e.metaKey) {
      e.preventDefault();
      const delta = -e.deltaY * 0.001;
      const newZoom = Math.min(Math.max(0.1, zoom.value + delta), 5);

      // Zoom towards mouse pointer
      // TODO: Implement proper zoom-to-point math
      zoom.value = newZoom;
    } else {
      pan.value.x -= e.deltaX;
      pan.value.y -= e.deltaY;
    }
  };

  // Selection
  const selectBlock = (id: string, multi = false) => {
    if (!multi) selectedIds.value.clear();
    selectedIds.value.add(id);
  };

  const clearSelection = () => {
    selectedIds.value.clear();
  };

  return {
    zoom,
    pan,
    gridSize,
    showGrid,
    snapToGrid,
    selectedIds,
    snap,
    startPan,
    handlePan,
    stopPan,
    handleWheel,
    selectBlock,
    clearSelection,
  };
};
