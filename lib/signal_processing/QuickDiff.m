function y = QuickDiff(X, Y)

dx = X;
dy = Y;
dx(:, :) = [X(2, :)-X(1, :); X(3:end, :)-X(1:end-2, :); X(end, :)-X(end-1,:)];
dy(:, :) = [Y(2, :)-Y(1, :); Y(3:end, :)-Y(1:end-2, :); Y(end, :)-Y(end-1,:)];
y = dy./dx;

