function get_segments(points, size)
	local thick_points = {}
	for i, point in ipairs(points) do
		if i == 1 then
			table.insert(thick_points, get_start_or_end(points[i], points[i + 1], size, true))
		elseif i == #points then
			table.insert(thick_points, get_start_or_end(points[i - 1], points[i], size, false))
		else
			table.insert(thick_points, get_bissector_points(points[i - 1], points[i], points[i + 1], size))
		end
	end
	pprint(thick_points)
	-- rearrange in polygons
	local segments = {}
	for i, point in ipairs(points) do
		if i == #points then
			break
		end 
		local polygon = {thick_points[i][1], thick_points[i+1][1], thick_points[i+1][2], thick_points[i][2]}
		table.insert(segments, polygon)
	end
	return segments
end

function get_bissector_points(a, b, c, size)
	-- http://math.stackexchange.com/questions/1460994/calculating-geometry-for-a-polyline-of-a-given-thickness
    local ab = b - a
    local n_a = vmath.normalize(vmath.vector3(-ab.y, ab.x, 0))
    local bc = c - b
    local n_b = vmath.normalize(vmath.vector3(-bc.y, bc.x, 0))
    local bissector = vmath.normalize(n_a + n_b)
    local k = 1 / vmath.dot(n_a, bissector)
    size = size / 2
    return {b - size * k * bissector, b + size * k * bissector}
end

function get_start_or_end(a, b, size, is_start)
	-- if it's start or end, normal to the segment
	local ab = b - a
	local n_ab = vmath.normalize(vmath.vector3(-ab.y, ab.x, 0))
	local start_point = b
	if is_start then
		start_point = a
	end
	size = size / 2
	return {start_point - n_ab * size, start_point + n_ab * size}
end