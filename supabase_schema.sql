-- =============================================
-- LA PIAZZA - Supabase Database Schema
-- Run this in your Supabase SQL Editor
-- =============================================

-- Tabla de pizzas
CREATE TABLE IF NOT EXISTS pizzas (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  descripcion TEXT,
  precio DECIMAL(10,2) NOT NULL,
  imagen_url TEXT,
  categoria TEXT DEFAULT 'clasica',
  mas_vendida BOOLEAN DEFAULT FALSE,
  disponible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de órdenes
CREATE TABLE IF NOT EXISTS ordenes (
  id SERIAL PRIMARY KEY,
  numero_orden TEXT UNIQUE NOT NULL,
  cliente_nombre TEXT NOT NULL,
  cliente_telefono TEXT,
  cliente_direccion TEXT,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente','preparando','en camino','entregada','cancelada')),
  total DECIMAL(10,2) NOT NULL,
  notas TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de items de cada orden
CREATE TABLE IF NOT EXISTS orden_items (
  id SERIAL PRIMARY KEY,
  orden_id INTEGER REFERENCES ordenes(id) ON DELETE CASCADE,
  pizza_id INTEGER REFERENCES pizzas(id),
  pizza_nombre TEXT NOT NULL,
  cantidad INTEGER NOT NULL DEFAULT 1,
  precio_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL
);

-- Insertar pizzas de muestra
INSERT INTO pizzas (nombre, descripcion, precio, imagen_url, categoria, mas_vendida) VALUES
('Jamón y Queso', 'Nuestra estrella: salsa de tomate artesanal, mozzarella premium, jamón cocido selecto y queso gouda fundido. ¡La más pedida!', 12.99, null, 'clasica', TRUE),
('Margarita', 'La clásica italiana: salsa de tomate san marzano, mozzarella fresca di bufala y albahaca fresca', 10.99, null, 'clasica', FALSE),
('Pepperoni Suprema', 'Doble capa de pepperoni americano, mozzarella y orégano mediterráneo', 13.99, null, 'clasica', FALSE),
('4 Quesos', 'Fusión de mozzarella, gorgonzola, parmesano y queso de cabra sobre base blanca', 14.99, null, 'especial', FALSE),
('Pollo BBQ', 'Salsa BBQ ahumada, pollo a la parrilla, cebolla caramelizada y jalapeños', 13.49, null, 'especial', FALSE),
('Vegetariana', 'Pimientos de colores, champiñones, aceitunas negras, rúcula y queso feta', 11.99, null, 'vegetariana', FALSE),
('Napolitana', 'Tomates cherry asados, anchoas, alcaparras, aceitunas y mozzarella ahumada', 13.99, null, 'clasica', FALSE),
('Hawaiana Tropical', 'Jamón dulce, piña natural, queso mozzarella y un toque de miel', 12.49, null, 'especial', FALSE),
('Trufa Negra', 'Crema de trufa negra, champiñones porcini, parmesano y rúcula fresca', 16.99, null, 'gourmet', FALSE),
('Diavola', 'Salami piccante, nduja calabresa, guindilla y mozzarella ahumada', 14.49, null, 'especial', FALSE),
('Salmón & Rúcula', 'Salmón ahumado noruego, crema fraîche, alcaparras y rúcula baby', 15.99, null, 'gourmet', FALSE),
('Prosciutto & Higos', 'Prosciutto di Parma, higos frescos, gorgonzola y nueces caramelizadas', 15.49, null, 'gourmet', FALSE);

-- Enable Row Level Security (opcional para producción)
ALTER TABLE ordenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE orden_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE pizzas ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas para acceso público (ajusta según tus necesidades)
CREATE POLICY "Allow public read pizzas" ON pizzas FOR SELECT USING (true);
CREATE POLICY "Allow public insert ordenes" ON ordenes FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public read ordenes" ON ordenes FOR SELECT USING (true);
CREATE POLICY "Allow public insert orden_items" ON orden_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public read orden_items" ON orden_items FOR SELECT USING (true);
