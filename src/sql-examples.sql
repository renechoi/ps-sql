select CName, CAddr
from tCustomer as tcu
where CAddr = '부산시 남구'
order by CName asc;


select CAddr, count(CAddr)
from tCustomer
group by CAddr
having count(CAddr)> 2;


select EName, DNumber, (case DNumber
                            when 'D1001' then '문구생산부'
                            when 'D2001' then '가구생산부'
                            when 'D3001' then '악세사리생산부'
                            when 'D4001' then '전자기기생산부'
                            else '부서없음'
    end) as 부서명
from tEmployee as tem
order by EName;



select ename, dnumber, (case when DNumber = 'D1001' then '문구생산부' else '부서 없음' end) as '부서명'
from tEmployee as tem
order by ename;


select tde.DName, tem.EName
    from tDepartment as tde
inner join tEmployee as tem
on tde.DNumber = tem.DNumber
order by tem.EName;


select substr('과수원의 사과는 맛있다', 1,2);

select ltrim('과수원의 사과');

select CName, coalesce(tCustomer.CName, '관리자')
from tCustomer





