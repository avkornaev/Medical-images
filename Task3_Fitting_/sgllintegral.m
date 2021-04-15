%Подпрограмма расчета двойного интеграла двойным применением формулы
%Симпсона. Пределы интегрирования от 0 до 1
function [integ]=sgllintegral(f)
%int=0;
nx=length(f);
x1=linspace(0,1,nx);
dx1=x1(2)-x1(1);
integ=0;
for i=2:2:nx-1
    integ=integ+(f(i-1)+4*f(i)+f(i+1))*dx1/3;
end
if mod(nx,2)==0 %четное количество точек интегрирования
    integ=integ+0.5*dx1*(f(nx)+f(nx-1));%добавочный забытый кусок
end

end
