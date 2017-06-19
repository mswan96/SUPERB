hold on

for y10 = [-6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]
for y20 =  [-2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5] %[0 0.5 1 1.5 2 2.5]

    [ts,ys] = ode45('twobody',[0 500],[y10;y10;y20;y20]); 
    
    plot(ys(:,1),ys(:,3))
    ylim([-2.5, 2.5])
    xlim([-6, 6])
    %plot(ys(1,1),ys(1,2),'bo') % starting point
    %plot(ys(end,1),ys(end,2),'ks') % ending point
end
end

hold off