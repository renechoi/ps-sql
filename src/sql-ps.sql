# 1. (SFWO)
#    문구생산부와 가구생산부의 직원정보를 확인하려한다.
# 위에 해당하는 직원들의 직원명과 입사일을 입사일이 빠른 순서대로 출력하세요.
# (문구생산부의 DNumber는 'D1001', 가구생산부는 'D2001'이며 입사일은 연,월,일까지만 출력되어야 한다)


select *
from tEmployee;

select EName as 직원명, date_format(StartDate, '%Y-%m-%d') as 입사일
from tEmployee
where DNumber = 'D1001'
   or DNumber = 'D2001'
order by StartDate asc;

select EName as 직원명, date_format(StartDate, '%Y-%m-%d') as 입사일
from tEmployee
where DNumber in ('D1001', 'D2001')
order by StartDate;


#
# 2. (SFWO)
#    2020년 크리스마스부터 입사일이 만 2년이 넘어가는 사람에게 보너스를 지급하려고 한다. 위 조건에 해당하는 직원의 직원명과 입사일을 출력하시오.
# (단, 정렬은 고려하지 않는다)


select EName as 직원명, StartDate as 입사일
from tEmployee
where TIMESTAMPDIFF(YEAR, StartDate, '2020-12-25') > 2;


# 3. (GROUP BY)
#    생산량 조정을 위해 2020년 2월의 총 생산량을 알려고 한다.
# 해당 월에 생산된 제품들의 코드와 해당 제품들의 총 생산량을 출력하시오.

select *
from tProduction;

select sum(PCount) as 총생산량, INumber as 제품코드
from tProduction
where PDate between '2020-02-01' and '2020-03-01'
group by INumber;



# 4. (GROUP BY)
#    가구류 제품들의 선호도 조사를 위하여 고객들이 가구류 제품들의 주문을 몇 번 했는지 고객코드별로 출력하시 오. (가구류의 생산코드는 P2~로 시작한다)


# 5. (GROUP BY, HAVING)
#    2020년 1월의 성실직원을 뽑기 위해 성실직원의 기준인 생산량 500개 이상을 달성한 인원들의 직원코드와 총 생산량을 출력하시오.

select ENumber as 직원번호, sum(PCount) as 총생산량
from tProduction
where PDate between '2020-01-01' and '2020-02-01'
group by ENumber
having 총생산량 > 500;



#
# 6. (CASE WHEN)
#    판매 가능한 제품들의 재고 파악을 위해 2020년 2월에 생산된 양을 확인하려하는데 우선 문구류 제품들을 먼저 파악하려 한다.
#    해당 제품명과 제품들의 총 생산량을 출력하시오.
# (문구류의 제품코드(INumber)는 I100(1~5)이며 1번은 가위, 2번은 풀, 3번은 공책, 4번은 볼펜, 5번은 지우개이다, ex - I1001 = 가위)


select (case INumber
            when 'I1001' then '가위'
            when 'I1002' then '풀'
            when 'I1003' then '공책'
            when 'I1004' then '볼펜'
            when 'I1005' then '지우개'
    end) as 문구류제품,
       PCount
from tProduction
where PDate between '2020-02-01' and '2020-03-01';


select case
           when tProduction.INumber = 'I1001' then '가위'
           when tProduction.INumber = 'I1002' then '풀'
           when tProduction.INumber = 'I1003' then '공책'
           when tProduction.INumber = 'I1004' then '볼펜'
           when tProduction.INumber = 'I1005' then '지우개'
           end     as 제품명,
       sum(PCount) as 총생산량
from tProduction
where date_format(PDate, '%Y-%m') = '2020-02'
  and substring(INumber, 1, 2) = 'I1'
group by INumber;


#
# 7. (UNION)
#    제품이 한번이라도 주문됐거나, 반품이 한번이라도 발생한 월의 정보를 알아보려고한다. 위, 조건에 해당하는 월들을 중복을 제거하고 출력하시오.

select *
from tOrder;

select *
from tReturn;


select date_format(tOrder.ODate, '%m') as 주문_및_반품월
from tOrder
group by 주문_및_반품월
union
select date_format(tReturn.RDate, '%m') as 주문_및_반품월
from tReturn
group by 주문_및_반품월;



#     8. (UNION ALL)
#        여태까지 회사에 입사했던 사람들의 총 인원 수와 연도별 입사한 직원 수를 출력하시오.


select *
from tEmployee;

select '총인원수' as 입사년도, count(*) as 입사한직원수
from tEmployee as tem1
union all
select date_format(tem2.StartDate, '%Y') as 연도, count(*)
from tEmployee as tem2
group by 연도;


#
# 9. (서브쿼리 COLUMN)
#    회사에서 제공해주는 기숙사에 머무를 수 있는 인원의 제한을 위해 부서와 직급, 그리고 현재 거주지를 따져 제한하려고 한다.
#    이에 따라 부서명과 직급명, 직원명 그리고 현재 직원의 주소를 출력하시오
# (부서코드, 직급코드가 아닌 부서명, 직급명으로 출력되어야 한다.)

select *
from tDepartment;

select *
from tEmployee;

select *
from tRank;



select (select tDepartment.DName
        from tDepartment
        where tDepartment.DNumber = tem.DNumber)                         as 부서명,
       (select tRank.RName from tRank where tRank.RNumber = tem.RNumber) as 직급명,
       tem.EAddr                                                         as 직원주소
from tEmployee as tem;


#
# 10. (서브쿼리 WHERE)
#     회사 내 전 직원들의 평균 생산량보다 한번이라도 많이 생산한 직원들에게는 상여금을 주려한다.
#     이에 해당하는 직원명을 출력하시오 (생산량은 tProduction 테이블의 PCount이다.)


select *
from tEmployee;

select *
from tProduction;

select tem.EName as 직원명
from tEmployee tem
where tem.ENumber
          in (select tpr1.ENumber
              from tProduction as tpr1
              where tpr1.PCount > (select Avg(tpr2.PCount)
                                   from tProduction tpr2));




# 12. (서브쿼리 FROM)
#     2021년부터 판매가 시작됨에 따라 지난 1년(20년 1월 1일 ~ 20년 12월 31일) 동안 생산된 제품들의 제품코드와
#     총 생산량을 생산량이 많은 순으로 확인하려한다.
#     위의 조건에 맞춰 출력하시오.


select *
from tProduction;


select tpr1.INumber as 제품코드, tpr1.PCount as 총생산량
from (select tProduction.INumber, sum(tProduction.PCount) as PCount
           from tProduction
            where tProduction.PDate between '2020-01-01' and '2020-12-31'
            group by tProduction.INumber
            ) as tpr1
order by 총생산량 desc;