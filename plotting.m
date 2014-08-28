color = [255 	106 	106]/255;
filename = 'twocircle.gif';
figure(1)
circle0 = [cos(0:.1:2*pi)', sin(0:.1:2*pi)'];
i = [1 42 95 135];
for j = 1:4
    clf
    journalfig(5)
    patch(circle0(:,1),circle0(:,2),[.8,.9,1], 'EdgeColor', [.8,.9,1])
    axis('off')
    axis('square')
    hold on
    t = i(j);
    x = result(t).x; y =result(t).y;
    patch(x,y, color, 'EdgeColor', color)
    plot(x0(1:6:end),y0(1:6:end),'k--')
    T = t*H/5;
    title(['T = ' num2str(T)], 'FontSize', 18)
    %pause
    print('-depsc',strcat('offcentercircle',num2str(j)))
%     frame = getframe(1);
%     
%     im = frame2im(frame);
%     
%     [imind,cm] = rgb2ind(im,256);
%     
%     if i == 1;
%         
%         imwrite(imind,cm,filename,'gif','Delaytime', 0, 'Loopcount',inf);
%         
%     else
%         
%         imwrite(imind,cm,filename,'gif','Delaytime', 0,'WriteMode','append');
%         
%     end
end