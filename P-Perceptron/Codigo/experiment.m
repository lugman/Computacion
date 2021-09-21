#!/usr/bin/octave -qf
if(nargin != 3)
  printf("Usage: ./experiment.m <data><alphas><bes>\n"); exit; end
arg_list=argv();
data=arg_list{1};
as=str2num(arg_list{2});
bs=str2num(arg_list{3});
load(data); [N,L]=size(data);  D=L-1;
ll=unique(data(:,L)); C=numel(ll);
rand("seed", 23); data=data(randperm(N),:);
NTr=round(.7*N); M=N-NTr; te=data(NTr+1:N,:);
printf("#       a       b   E   k Ete  Ete(%%)      Ite(%%)\n");
printf("#-------- ------- --- --- --- -------- --------------\n");
for a=as
  for b=bs
  [w,E,k] = perceptron(data(1:NTr,:),b,a); rl=zeros(M,1);
  for n=1:M rl(n)=ll(linmach(w,[1 te(n,1:D)]')); end
  [nerr m] = confus(te(:,L),rl);
  m=nerr/M; s=sqrt(m*(1-m)/M); r=1.96*s;
  printf("%8.1f %8.1f %3d %3d %3d %7.1f [%3.1f, %3.1f]\n",
  	a,b,E,k,nerr,100.0*m,100.0*max(0.0,(m-r)), 100.0*(m+r));
  end
end


