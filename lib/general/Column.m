function y = Column(y)

if ~iscolumn(y)
	y = reshape(y, [], 1);
end

end
