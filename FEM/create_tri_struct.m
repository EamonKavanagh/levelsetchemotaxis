function triStruct = create_tri_struct(p,t)

triStruct = struct('nodes',[], 'triangles', []);

for i = 1:length(p)
    triStruct(i).nodes = p(i,:);
end

for i = 1:length(t)
   nodes = t(i,:);
   for j = 1:size(t,2)
      triStruct(nodes(j)).triangles(end+1) = i;
   end
end