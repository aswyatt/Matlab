function y = Row(y)

if ~isrow(y)
	y = reshape(y, 1, []);
end

end
