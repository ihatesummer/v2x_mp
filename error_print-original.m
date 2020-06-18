result_all=[];
% temp=1;
fid=fopen('MP_niter_1_d_1to1000_velynoise02.txt','w');
    type1_1=['          abs_avg_total       abs_max_total      abs_min_total']; %6
    type1_2=[' abs_avg_anchor      abs_max_anchor      abs_min_anchor'];
    type1_3=['abs_avg_agent       abs_max_agent       abs_min_agent'];
 
    type2_1=['rel_avg_total        rel_max_total       rel_min_total'];
    type2_2=['rel_avg_anchor      rel_max_anchor      rel_min_anchor'];
    type2_3=['rel_avg_agent      rel_max_agent      rel_min_agent'];
 
    fprintf(fid,'%s      %s      %s      %s      %s      %s',type1_1,type1_2,type1_3,type2_1,type2_2,type2_3);
    fprintf(fid,'\r\n');
for d=0:5:1000     %200   

    for a=1:100    %100

 
        vard=1;  % (D_error*100)/100
        vartheta=(pi/180*3)^2;  % (A_error*10)/10,  degree; 
        nveh=10;    % number of vehivles
        %iteration=1:1:100; % cooperation iteration.
        niter=1;
 
 
 
 
        %initial Position 
        p1=0;
        p2=0;
        p3=0;
        p4=0;
        p5=d;
        p6=0;
        p7=0;
        p8=0;
        p9=0;
        p10=0;
 
         
        varux=0.1; % x-axis vehicle movement variation
        varuy=1; % y-axis vehicle movement variation
        nlan=5; %number of lanes
        tdelta=0.1; %time interval
        velx=0; %average velocity along x-axis
 
        %velocity
        vely=36; %36
        vely2=36; %36
        vely3=36; %36
        vely4=36;  %36
 
        % Anchor?äî Í∞??ö¥?ç∞?óê ?Ñ£Í∏?
        anchor=round(nveh/2);
 
        vpos_y=[p1 p2 p3 p4 p5 p6 p7 p8 p9 p10]';
        vpos_y=vpos_y+randn(nveh,1);
        vpos_x=[1 1 2 2 3 3 4 4 5 5]';
        vpos=[vpos_x vpos_y];
 
 
         while ~isequal(sortrows(vpos),unique(vpos,'rows'))
            vpos_y=[p1 p2 p3 p4 p5 p6 p7 p8 p9 p10]';
            vpos_y=vpos_y+randn(10,1); 
            vpos_x=[1 1 2 2 3 3 4 4 5 5]';
            vpos=[vpos_x vpos_y];
         end
 
 
        vpos=repmat([3.5 1],[size(vpos,1) 1]).*vpos;  %?èÑÎ°? ?è≠?ùÑ 3.5mÎ°? ?ë†.
 
        %true distance
        trdist=sqrt(sum((repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1])).^2,3)); 
        %observed distance
        zijn=trdist+sqrt(vard)*randn(size(trdist)); 
        zijn(1:nveh+1:end)=0; %=zijn-diag(diag(zijn));
 
        traoa=(repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1]));
        traoa=atan(traoa(:,:,2)./traoa(:,:,1))+(traoa(:,:,1)<0)*pi;
        traoa(1:nveh+1:end)=0;
 
        thetaijn=traoa+sqrt(vartheta)*randn(size(traoa));
        thetaijn(1:nveh+1:end)=0;
 
        %colmap=colormap('lines');
        mode1=1;
 
 
        % Axes 4
        vposhist(:,:,1)=vpos; % history of positions of vehicles
        trdisthist(:,:,1)=trdist; % history of true distance
        obdisthist(:,:,1)=zijn; % history of observed distance
        traoahist(:,:,1)=traoa; % history of true aoa
        obaoahist(:,:,1)=thetaijn; % history of observed aoa
 
 
        %Gaussian approximation
        % Line 4
        fimean1=vpos+sqrt(vard)/2*randn(size(vpos)); %initial message parameter definition
        belmean1=fimean1; %initial belief
        belmeanhist1(:,:,1)=belmean1;
 
        if mode1,
            %relative error
            % 10???ùò Ï∞®Îüâ xÏ¢åÌëú ?Ç¨?ù¥ Í±∞Î¶¨
            disthist1(:,:,1)=(repmat(belmeanhist1(:,1,1),[1 nveh])-repmat(belmeanhist1(:,1,1).',[nveh 1])).^2;
 
 
 
            %10???ùò Ï∞®Îüâ (x,y) Ï¢åÌëú Í±∞Î¶¨ Î£®Ìä∏((x-x1).^2 +(y-y1).^2) =>(??Í∞ÅÌñâ?†¨) Ï§ëÏã¨??Í∞ÅÏÑ†Í∞íÏ? ?ãπ?ó∞?ûà 0
            % Ï∂îÏ†ïÍ∞?
            disthist1(:,:,1)=sqrt(disthist1(:,:,1)+(repmat(belmeanhist1(:,2,1),[1 nveh])-repmat(belmeanhist1(:,2,1).',[nveh 1])).^2);
 
 
 
 
            % disthist?? Í∞ôÏ? ?õêÎ¶? , trposhist?äî ?ã§?†ú Ï¢åÌëúÎ°? Í±∞Î¶¨Ï∞?.
            trposhist(:,:,1)=sqrt((repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1])).^2 ...
            +(repmat(vposhist(:,2,1),[1 nveh])-repmat(vposhist(:,2,1).',[nveh 1])).^2);
            relerror1(1)=mean(mean(abs(trposhist(:,:,1)-disthist1(:,:,1)),1),2);
 
            %absolute error
            abserror1(1)=mean(sqrt(sum((vposhist(:,:,1)-belmeanhist1(:,:,1)).^2,2)),1);
            % Ï¢åÌëúÍ∞íÏúºÎ°? Í≥ÑÏÇ∞?ïú ?†à?? ?ò§Î•? 
 
 
        else
            %relative error
            disthist1(:,:,1)=abs(repmat(belmeanhist1(:,1,1),[1 nveh])-repmat(belmeanhist1(:,1,1).',[nveh 1]));    
            trposhist(:,:,1)=abs(repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1]));
 
 
            relerror1(1)=mean(mean(abs(trposhist(:,:,1)-disthist1(:,:,1)),1),2);   
 
            %absolute error
            abserror1(1)=mean(abs(vposhist(:,1,1)-belmeanhist1(:,1,1)),1);    
 
        end  
        fivar1=vard*ones(size(vpos));  
        belvar1=fivar1;   
        belvarhist1(:,:,1)=belvar1;    
 
 
 
 
 
 
        % Line 6
 
        %time initialization
 
        ii=0;
 
        while num2str(1), % && ii<ntime, % time iteration
            ii=ii+1;
            vely=36;
            vely2=36;
            vely3=36;
            vely4=36;
            % factor to variable messge update (f_i --> x_{i,n})u
           for j=1:nveh
               if j==round(nveh/2)
                   fixinmean1(round(nveh/2),:)=belmean1(round(nveh/2),:)+[velx vely4]*tdelta+ sqrt(0.2)*(randn(1,2));
               else   
                    if vpos(j,1) < 8.5
                        fixinmean1(j,:)=belmean1(j,:)+[velx vely]*tdelta + sqrt(0.2)*(randn(1,2));
                    elseif vpos(j,1)>=8.5 && vpos(j,1)<13
                        fixinmean1(j,:)=belmean1(j,:)+[velx vely3]*tdelta + sqrt(0.2)*(randn(1,2));
                    else
                        fixinmean1=belmean1+repmat([velx vely2],[size(belmean1,1) 1])*tdelta + sqrt(0.2)*(randn(1,2));
                    end
               end 
           end
                fixinvar1=belvar1+repmat([varux varuy],[size(belvar1,1) 1]);
                intbelmean1=fixinmean1;
                intbelvar1=fixinvar1;
                xinfijmean1=intbelmean1;
                xinfijvar1=intbelvar1;
                fijxinmean1=zeros([size(zijn),2]);
                fijxinvar1=zeros([size(zijn),2]);
 
 
            % Line 9 % anchor=5
            for jj=1:niter, % cooperative positioning (intervehicular iteration)
                for kk=1:nveh,
                    for ll=1:nveh,
                        if kk~=ll,
                            if ll~=anchor %zijn(kk,ll)~=1,
                                if abs(zijn(kk,ll))>eps, %LOS
 
                                    % Line 11
                                    % factor to variable message update (f_{i,j} --> x_{i,n})
                                    varx1=vard*cos(thetaijn(kk,ll))^2+zijn(kk,ll)^2*vartheta*sin(thetaijn(kk,ll))^2;
                                    vary1=zijn(kk,ll)^2*vartheta*cos(thetaijn(kk,ll))^2+vard*sin(thetaijn(kk,ll))^2;
                                    fijxinmean1(kk,ll,:)=zijn(kk,ll)*[cos(thetaijn(kk,ll)) sin(thetaijn(kk,ll))]+xinfijmean1(ll,:);
                                    fijxinvar1(kk,ll,:)=xinfijvar1(ll,:)+[varx1 vary1];
 
                                end
                            else %if ll is a header
                                if abs(zijn(kk,ll))>eps, %LOS
                                    % Line 11
                                    % factor to variable message update (f_{i,j} --> x_{i,n})
                                    varx1=vard*cos(thetaijn(kk,ll))^2+zijn(kk,ll)^2*vartheta*sin(thetaijn(kk,ll))^2;
                                    vary1=zijn(kk,ll)^2*vartheta*cos(thetaijn(kk,ll))^2+vard*sin(thetaijn(kk,ll))^2;
                                    fijxinmean1(kk,ll,:)=zijn(kk,ll)*[cos(thetaijn(kk,ll)) sin(thetaijn(kk,ll))]+vpos(ll,:);
                                    fijxinvar1(kk,ll,:)=xinfijvar1(ll,:)+[varx1 vary1];
 
                                end
                            end
                        end
                    end
                end
                % Line 15
 
                %         intbelvar=1./(1./fixinvar+squeeze(sum(1./fijxinvar,2)));
                %         intbelmean=intbelvar.*(fixinmean./fixinvar+squeeze(sum(fijxinmean./fijxinvar,2)));
                for kk=1:nveh,
                    sumfijxinvar1=[0 0];
                    sumfijxinmean1=[0 0];
                    for ll=1:nveh,
                        if kk~=ll,
                            if abs(zijn(kk,ll))>eps,
 
                               sumfijxinvar1=sumfijxinvar1+squeeze(1./fijxinvar1(kk,ll,:)).';
                               sumfijxinmean1=sumfijxinmean1+squeeze(fijxinmean1(kk,ll,:)./fijxinvar1(kk,ll,:)).';
 
                            end
                        end
                    end
 
                    intbelvar1(kk,:)=1./(1./fixinvar1(kk,:)+sumfijxinvar1);
                    intbelmean1(kk,:)=intbelvar1(kk,:).*(fixinmean1(kk,:)./fixinvar1(kk,:)+sumfijxinmean1);
                end
                % Line 16
                % broadcast B
 
 
                xinfijmean1=intbelmean1;
                xinfijvar1=intbelvar1;
 
            end
 
 
             belmean1=intbelmean1;
             belvar1=intbelvar1;
             belmeanhist1(:,:,ii+1)=belmean1;
             belvarhist1(:,:,ii+1)=belvar1;
 
 
 
 
 
        %627
            vposhist(:,:,ii+1)=vpos; % update true position history
            trdist=sqrt(sum((repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1])).^2,3)); %true distance
            trdisthist(:,:,ii+1)=trdist; % history of true distance
            zijn=trdist+sqrt(vard)*randn(size(trdist)); %observed distance
            zijn=zijn-diag(diag(zijn));
            obdisthist(:,:,ii+1)=zijn;% history of observed distance
            traoa=(repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1]));
            traoa=atan(traoa(:,:,2)./traoa(:,:,1))+(traoa(:,:,1)<0)*pi;
            traoa(1:nveh+1:end)=0;
            traoathist(:,:,ii+1)=traoa; % history of true aoa
            thetaijn=traoa+sqrt(vartheta)*randn(size(traoa));
            thetaijn(1:nveh+1:end)=0;
            obaoahist(:,:,ii+1)=thetaijn; % history of observed distance
            mileage=round(max(vpos(:,2)));
            for j=1:nveh
                if j==round(nveh/2)
                    vpos(round(nveh/2),:)=vpos(round(nveh/2),:)+[velx vely4]*tdelta;
                else
                    if vpos(j,1) < 8.5
                        vpos(j,:)=vpos(j,:)+[velx vely]*tdelta;
                    elseif vpos(j,1)>=8.5 && vpos(j,1)<13
                        vpos(j,:)=vpos(j,:)+[velx vely3]*tdelta;
                    else
                        vpos(j,:)=vpos(j,:)+[velx vely2]*tdelta;
                    end
                end
            end
           % vpos=vpos+repmat([velx vely],[size(vpos,1) 1])*tdelta; % update true positions
 
 
 
            if mode1,
                %relative error
                disthist1(:,:,ii+1)=(repmat(belmeanhist1(:,1,ii+1),[1 nveh])-repmat(belmeanhist1(:,1,ii+1).',[nveh 1])).^2;
                disthist1(:,:,ii+1)=sqrt(disthist1(:,:,ii+1)+(repmat(belmeanhist1(:,2,ii+1),[1 nveh])-repmat(belmeanhist1(:,2,ii+1).',[nveh 1])).^2);
 
                trposhist(:,:,ii+1)=sqrt((repmat(vposhist(:,1,ii+1),[1 nveh])-repmat(vposhist(:,1,ii+1).',[nveh 1])).^2+(repmat(vposhist(:,2,ii+1),[1 nveh])-...
                                    repmat(vposhist(:,2,ii+1).',[nveh 1])).^2);
 
 
 
                for_error=abs(trposhist(:,:,ii+1)-disthist1(:,:,ii+1));       
                for_error_agent=for_error(1,:);
              % for anchor and agent
                for j=2:nveh
                    if j==anchor                
                        for_error_anchor=for_error(j,:);
                    else
                        for_error_agent=horzcat(for_error_agent,for_error(j,:));
                    end
                end
 
                relerror1_anchor(ii+1)=mean(for_error_anchor,2);
                relerror1_anchor_avg=sum(relerror1_anchor)/ii;
 
                relerror1_agent(ii+1)=mean(mean(for_error_agent,2),1);
                relerror1_agent_avg=sum(relerror1_agent)/ii;       
 
                %******************************************************************
                % for relative anchor error
                print_relerror1_anchor_avg=round(relerror1_anchor_avg,3);
                print_max_relerror1_anchor=max(round(relerror1_anchor,3));
                print_min_relerror1_anchor=min(round(relerror1_anchor(2:ii+1),3));
 
                %******************************************************************
                % for relative agent error 
                print_relerror1_agent_avg=round(relerror1_agent_avg,3);
                print_max_relerror1_agent=max(round(relerror1_agent,3));
                print_min_relerror1_agent=min(round(relerror1_agent(2:ii+1),3));
 
                %******************************************************************
                % for total error   
                relerror1(ii+1)=mean(mean(for_error,1),2);
                relerror1_avg=sum(relerror1)/ii;
 
                print_relerror1_avg=round(relerror1_avg,3);
                print_max_relerror1=max(round(relerror1,3));
                print_min_relerror1=min(round(relerror1,3)); 
 
 
 
 
                % absolute error
                for_abs_error=(vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2;      
 
                % for anchor and agent
                abserror1_anchor(ii+1)=(sqrt(sum(vposhist(anchor,:,ii+1)-belmeanhist1(anchor,:,ii+1)).^2));
                for_abs_error(anchor,:)=[];
                abserror1_agent(ii+1)= (sum(sqrt(sum(for_abs_error,2)),1))/(nveh-length(anchor));
 
                abserror1_anchor_avg=sum(abserror1_anchor)/ii;
                abserror1_agent_avg=sum(abserror1_agent)/ii;
 
 
                %******************************************************************
                % for absolute anchor error
 
                print_abserror1_anchor_avg=round(abserror1_anchor_avg,3);
                print_max_abserror1_anchor=max(round(abserror1_anchor,3));
                print_min_abserror1_anchor=min(round(abserror1_anchor(2:ii+1),3));       
 
                %******************************************************************
                % for absative agent error 
                print_abserror1_agent_avg=round(abserror1_agent_avg,3);
                print_max_abserror1_agent=max(round(abserror1_agent,3));
                print_min_abserror1_agent=min(round(abserror1_agent(2:ii+1),3));    
 
 
                %******************************************************************
                % for total error  
                abserror1(ii+1)=mean(sqrt(sum((vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2,2)),1);
                abserror1_avg=sum(abserror1)/ii;
 
                print_abserror1_avg=round(abserror1_avg,3);
                print_max_abserror1=max(round(abserror1,3));
                print_min_abserror1=min(round(abserror1,3));        
 
 
            else
 
                %mode1 Í≥? Î¨¥Ïóá?ùÑ ?ã§Î•¥Í≤å ?ëê?ñ¥?ïº ?ïò?äîÏß?..       
                %relative error
                disthist1(:,:,ii+1)=abs(repmat(belmeanhist1(:,1,ii+1),[1 nveh])-repmat(belmeanhist1(:,1,ii+1).',[nveh 1]));
                trposhist(:,:,1)=abs(repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1]));
 
                 
                for_error=abs(trposhist(:,:,ii+1)-disthist1(:,:,ii+1));       
                for_error_agent=for_error(1,:);
              % for anchor and agent
                for j=2:nveh
                    if j==anchor                
                        for_error_anchor=for_error(j,:);
                    else
                        for_error_agent=horzcat(for_error_agent,for_error(j,:));
                    end
                end
 
                relerror1_anchor(ii+1)=mean(for_error_anchor,2);
                relerror1_anchor_avg=sum(relerror1_anchor)/ii;
 
                relerror1_agent(ii+1)=mean(mean(for_error_agent,2),1);
                relerror1_agent_avg=sum(relerror1_agent)/ii;        
 
                %******************************************************************
                % for relative anchor error
                print_relerror1_anchor_avg=round(relerror1_anchor_avg,3);
                print_max_relerror1_anchor=max(round(relerror1_anchor,3));
                print_min_relerror1_anchor=min(round(relerror1_anchor(2:ii+1),3));
 
                %******************************************************************
                % for relative agent error 
                print_relerror1_agent_avg=round(relerror1_agent_avg,3);
                print_max_relerror1_agent=max(round(relerror1_agent,3));
                print_min_relerror1_agent=min(round(relerror1_agent(2:ii+1),3));
 
 
 
                %******************************************************************
                % for total error   
                relerror1(ii+1)=mean(mean(for_error,1),2);
                relerror1_avg=sum(relerror1)/ii;
 
                print_relerror1_avg=round(relerror1_avg,3);
                print_max_relerror1=max(round(relerror1,3));
                print_min_relerror1=min(round(relerror1,3));
 
 
 
 
        %------------------------------------------------------------------------------------------------------------
                % absolute error
                %abserror1(ii+1)=mean(abs(vposhist(:,1,ii+1)-belmeanhist1(:,1,ii+1)),1)
                %?õê?ûò ?úÑ ?ãù?ù∏?ç∞, mode 1 Í≥? else Í∞? Î¨¥Ïä®Ï∞®Ïù¥?ù∏Ïß? Î™®Î•¥Í≤†Í≥†, xÏ∂ïÎßå Í≥ÑÏÇ∞?êò?ñ¥ ?ûà?úºÎØ?Î°? ?ö∞?Ñ† mode 1 Í≥? ?èô?ùº?ïòÍ≤? ?ë†.
 
                for_abs_error=(vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2;      
 
                % for anchor and agent
                abserror1_anchor(ii+1)=(sqrt(sum(vposhist(anchor,:,ii+1)-belmeanhist1(anchor,:,ii+1)).^2));
                for_abs_error(anchor,:)=[];
                abserror1_agent(ii+1)= (sum(sqrt(sum(for_abs_error,2)),1))/(nveh-length(anchor));
 
                abserror1_anchor_avg=sum(abserror1_anchor)/ii;
                abserror1_agent_avg=sum(abserror1_agent)/ii;
 
 
                %******************************************************************
                % for absolute anchor error
 
                print_abserror1_anchor_avg=round(abserror1_anchor_avg,3);
                print_max_abserror1_anchor=max(round(abserror1_anchor,3));
                print_min_abserror1_anchor=min(round(abserror1_anchor(2:ii+1),3));       
 
                %******************************************************************
                % for absative agent error 
                print_abserror1_agent_avg=round(abserror1_agent_avg,3);
                print_max_abserror1_agent=max(round(abserror1_agent,3));
                print_min_abserror1_agent=min(round(abserror1_agent(2:ii+1),3));      
 
 
                %******************************************************************
                % for total error  
                abserror1(ii+1)=mean(sqrt(sum((vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2,2)),1);
                abserror1_avg=sum(abserror1)/ii;
 
                print_abserror1_avg=round(abserror1_avg,3);
                print_max_abserror1=max(round(abserror1,3));
                print_min_abserror1=min(round(abserror1,3));        
 
 
            end
            ii;
            if ii==1000  %how long? 15min
                break
            end
        end

 
 
        result1_1=[print_abserror1_avg,print_max_abserror1,print_min_relerror1]';
        result1_2=[print_abserror1_anchor_avg,print_max_abserror1_anchor,print_min_relerror1_anchor]';
        result1_3=[print_abserror1_agent_avg,print_max_abserror1_agent,print_min_relerror1_agent]';
        result2_1=[print_relerror1_avg,print_max_relerror1,print_min_relerror1]';
        result2_2=[print_relerror1_anchor_avg,print_max_relerror1_anchor,print_min_relerror1_anchor]';
        result2_3=[print_relerror1_agent_avg,print_max_relerror1_agent,print_min_relerror1_agent]';
        result=vertcat(result1_1,result1_2,result1_3,result2_1,result2_2,result2_3);
        result_all=[result_all,result];
 
    end
 
end
for mm=1:20000   
    fprintf(fid,'%20f',result_all(:,mm));
    fprintf(fid,'\r\n');
end
fclose(fid);