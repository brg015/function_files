function smart_err(err)

fprintf('\n--MATLAB ERROR--\n');
win_print(['Error: ' err.message '\n']);
if ~isempty(err.stack)
	win_print(['Error in: ' err.stack(1).name ' @ line ' num2str(err.stack(1).line) '\n\n']);
else
	win_print('\n');
end

end