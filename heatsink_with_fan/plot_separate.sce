clear;

file="one.csv";

// TTC placement with respect to the fan
// A1 A2 A3 A4
// B1 B2 B3 B4  <- air direction
// C1 C2 C3 C4
// D1 D2 D3 D4
//
// One line of the file contains the the temperatures in the following order
// A1 A2 A3 A4 B1 B2 B3 B4 C1 C2 C3 C4 D1 D2 D3 D4

function index=rc2index(r,c)
    index=c+4*(r-1);
endfunction

a=fscanfMat(file);

v=a(:,1:16);
i=a(:,17:17+15);
t=a(:,17+16:17+16+15);

[r,c]=size(a);
time=0:r-1;
time=time/10; //Sample rate 10Hz
time=time';

figure(1);
clf
for r=1:4
    for c=1:4
        subplot(4,4,rc2index(r,c));
        plot(time,t(:,rc2index(r,c)),'k');
        //NOTE: scaling of the power is only to have it fit nicely in the
        //plot together with the temperature. If you wan to see actual power
        //in Watts, you should remove scaling and just multiply v*i, and
        //move it to a separate plot
        plot(time,min(t)+1+5*(v(:,rc2index(r,c)).*i(:,rc2index(r,c))),'r');
        ax=get("current_axes");
        ax.data_bounds=[0,min(t);time($),max(t)];
    end
end

maxt=find(max(t,'c')==max(t));
maxt=maxt(1);
span=5;
tavg=t(maxt-span:maxt+span,:);
tavg=nanmean(tavg,'r');
printf("%s: temperatures at max t\n",file);
for r=1:4
    for c=1:4
        printf("%4.1f ",tavg(rc2index(r,c)));
    end
    printf("\n");
end
