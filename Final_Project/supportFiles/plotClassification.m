function [ax1, ax2] = plotClassification(V, classes, options)

if nargin == 2
    options.c1_style = {'ob', 'MarkerSize', 10};
    options.c2_style = {'+r', 'MarkerSize', 10};
    options.alpha    = mean(V);
end

allClass = unique(classes);
class1 = (classes == allClass(1));
class2 = (classes == allClass(2));

ax1 = plot(V(class1),0, options.c1_style{:}); hold on;
ax2 = plot(V(class2),0, options.c2_style{:});
plot(options.alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);
hold off; 

end
