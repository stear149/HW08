function[] = validityCheck(maxOutflow, QMaxAllowable, maxDepth, dMax)

if maxOutflow > QMaxAllowable
fprintf('**OUTFLOW FAILURE**  Max outflow from Pond β (%.5f m³/s) exceeds the allowable limit (%.2f m³/s).\n', maxOutflow, QMaxAllowable);
else
fprintf('**OUTFLOW PASS**  Max outflow (%.5f m³/s) is within the allowable limit (%.2f m³/s).\n',maxOutflow, QMaxAllowable);
end

if maxDepth(1) > dMax
    fprintf('**DEPTH FAILURE**    Max depth of Pond α (%.5f m) exceeds the allowable limit (%.2f m).\n', maxDepth(1), dMax);
else
    fprintf('**DEPTH PASS**    Max depth of Pond α (%.5f m) is within the allowable limit (%.2f m).\n', maxDepth(1), dMax);
end

if maxDepth(2) > dMax
    fprintf('**DEPTH FAILURE**    Max depth of Pond β (%.5f m) exceeds the allowable limit (%.2f m).\n', maxDepth(2), dMax);
else
    fprintf('**DEPTH PASS**    Max depth of Pond β (%.5f m) is within the allowable limit (%.2f m).\n', maxDepth(2), dMax);
end
if maxDepth(3) > dMax
    fprintf('**DEPTH FAILURE**    Max depth of Pond γ (%.5f m) exceeds the allowable limit (%.2f m).\n', maxDepth(3), dMax);
else
    fprintf('**DEPTH PASS**    Max depth of Pond γ (%.5f m) is within the allowable limit (%.2f m).\n', maxDepth(3), dMax);
end
