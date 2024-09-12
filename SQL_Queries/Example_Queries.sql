--1) Check status of his/her case
SELECT * FROM PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD WHERE P. AADHAR_NO=100000000001;

--2) Retrieve the next hearing date of his/her case.
SELECT * FROM DEFENDENT AS D NATURAL JOIN SCHEDULE 
AS S WHERE D. AADHAR_NO=100000000222;  

--3) By number of cases won.
SELECT * FROM LAWYER_DETAILS ORDER BY 
(TOTAL_CASES*WIN_PERCENTAGE/100) DESC;

--4) By percentage of cases won over total cases.
SELECT * FROM LAWYER_DETAILS ORDER BY
 WIN_PERCENTAGE DESC; 

--5) By years of experience.
SELECT * FROM LAWYER_DETAILS ORDER BY
 YEARS_OF_EXPERIENCE DESC;

--6) By consultancy fees.
SELECT * FROM LAWYER_DETAILS ORDER BY FEES DESC;

--7) By advocates field of speciality.
SELECT * FROM LAWYER_DETAILS WHERE
 LAWYER_TYPE='Contract_Lawyer';

--8) To find top 10 independent lawyers by total cases that are contract lawyer, has fees less than 50000, has minimum 10 years of experience, has won more than half of his cases and is located in Gujarat
SELECT * FROM LAWYER_DETAILS 
WHERE LAWYER_TYPE='Contract_Lawyer' 
AND ASSOCIATION_FLAG='Independent' 
AND FEES<50000 AND YEARS_OF_EXPERIENCE>10 
AND WIN_PERCENTAGE>50 
AND STATE='Gujarat' 
ORDER BY TOTAL_CASES DESC LIMIT 10;

--9) To study past cases of a particular type of case.
SELECT * FROM CASE_DETAILS WHERE 
CATEGORY='CRIMINAL APPEAL';

--10) To refer to different sections of IPC, CRPC and CPC
SELECT * FROM PENAL_CODE WHERE CODE_TYPE='IPC' AND 
SECTION_CODE='370A';

--11) Find the case status of a given case:
SELECT CASE_STATUS FROM CASE_DETAILS WHERE 
CASE_NO='GUJ100070040307';

--12) Check status of his/her clients case:
SELECT LITIGANT_NAME AS CLIENT_NAME, LAWYER_NAME, 
CD.* FROM LITIGANTS AS L
NATURAL JOIN PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD NATURAL JOIN ADVOCATED_BY AS AB 
NATURAL JOIN LAWYER_DETAILS AS LD
WHERE L.AADHAR_NO=100000000227
UNION
SELECT LITIGANT_NAME AS 
CLIENT_NAME,LAWYER_NAME,CD.* FROM LITIGANTS AS L 
NATURAL JOIN DEFENDENT AS D NATURAL JOIN 
CASE_DETAILS AS CD NATURAL JOIN ADVOCATED_BY AS AB 
NATURAL JOIN LAWYER_DETAILS AS LD
WHERE L.AADHAR_NO=100000000227;

--13) To use past verdicts as evidence in current case
SELECT C.CASE_NO,S.VERDICT,S.COURT_NAME,S.S_DATE AS
 DATE_OF_CASE, C.CATEGORY,C.CASE_STATUS,P.* FROM 
SCHEDULE AS S
NATURAL JOIN CASE_DETAILS AS C
NATURAL JOIN BASED_ON AS B 
JOIN PENAL_CODE AS P ON 
P.SECTION_CODE=B.SECTION_CODE AND 
P.CODE_TYPE=B.CODE_TYPE
WHERE S.VERDICT='Guilty' OR S.VERDICT='Not guilty';


--14) Check status of his/her clients case
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
 NATURAL JOIN PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD WHERE L.AADHAR_NO=100000000227
UNION
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L 
NATURAL JOIN DEFENDENT AS D NATURAL JOIN 
CASE_DETAILS AS CD WHERE L.AADHAR_NO=100000000227;

--15) Retrieve the next hearing date of his/her client
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L 
NATURAL JOIN PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD WHERE CD.CASE_NO='GUJ100070040307'
UNION
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
 NATURAL JOIN DEFENDENT AS D NATURAL JOIN 
CASE_DETAILS AS CD WHERE CD.CASE_NO='GUJ100070040307';

--16) To find past record of person
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
 NATURAL JOIN PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD WHERE L.AADHAR_NO=100000000227
UNION
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
 NATURAL JOIN DEFENDENT AS D NATURAL JOIN 
CASE_DETAILS AS CD WHERE L.AADHAR_NO=100000000227;

--17) Give the past details of the litigants of a case
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
NATURAL JOIN PLAINTIFF AS P NATURAL JOIN 
CASE_DETAILS AS CD WHERE 
CD.CASE_NO='GUJ100070040307'
UNION
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L
NATURAL JOIN DEFENDENT AS D NATURAL JOIN 
CASE_DETAILS AS CD WHERE 
CD.CASE_NO='GUJ100070040307';

--18) To find the data from the previous hearings of a current case
SELECT CD.,S. FROM SCHEDULE AS S NATURAL JOIN 
CASE_DETAILS AS CD 
WHERE CD.CASE_NO='JAM100020085302' AND S.VERDICT IS
NOT NULL;

--19) Get the details of witnesses from plaintiff side which will be 
present in the next hearing of case
SELECT W.*,JUDGE_ID,JUDGE_NAME,COURT_NAME 
FROM ( SELECT * FROM WITNESSES NATURAL JOIN APPEARED_IN)AS W NATURAL JOIN 
SCHEDULE AS S NATURAL JOIN ADJUDICATED_BY AS AB 
NATURAL JOIN JUDGE_DETAILS AS JD 
WHERE CALLED_BY='PLAINTIFF SIDE' AND S.VERDICT
ISNULL AND S.S_DATE=TESTIMONY_DATE;

--20) Select lawyer from a particular state
SELECT * FROM LAWYER_DETAILS WHERE AEN LIKE 
'%MAH%';

--21) Retrieve all past case history of all plaintiff and defendent of a particular Case given the Case_no
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L 
NATURAL JOIN PLAINTIFF AS P 
NATURAL JOIN CASE_DETAILS AS CD 
WHERE L.AADHAR_NO IN (SELECT L.AADHAR_NO FROM
LITIGANTS AS L NATURAL JOIN PLAINTIFF AS P NATURAL 
JOIN CASE_DETAILS AS CD WHERE 
CD.CASE_NO='GUJ100070040307')
UNION
SELECT L.LITIGANT_NAME,CD.* FROM LITIGANTS AS L 
NATURAL JOIN DEFENDENT AS D 
NATURAL JOIN CASE_DETAILS AS CD 
WHERE L.AADHAR_NO IN (SELECT L.AADHAR_NO FROM
LITIGANTS AS L NATURAL JOIN DEFENDENT AS D NATURAL 
JOIN CASE_DETAILS AS CD WHERE 
CD.CASE_NO='GUJ100070040307');

--22) Find criminal cases
SELECT * FROM CASE_DETAILS AS C WHERE C.CATEGORY 
LIKE '%criminal%';

--23) Find civil cases
SELECT * FROM CASE_DETAILS AS C WHERE C.CATEGORY
 LIKE '%Civil%'  OR C.CATEGORY LIKE '%civil%';

--24) Find miscellaneous cases
SELECT * FROM CASE_DETAILS AS C WHERE C.CATEGORY 
NOT LIKE '%CRIMINAL%'  AND C.CATEGORY NOT LIKE 
'%civil%'  AND C.CATEGORY NOT LIKE '%Civil%';

--25) Find the complete working details of a particular court for a particular judge heading a particular committee 
SELECT R.*,JD.JUDGE_NAME,CO.COMMITEE_TYPE
FROM REGISTRARS AS R NATURAL JOIN COURTS AS C
NATURAL JOIN JUDGE_DETAILS AS JD NATURAL JOIN COMMITTEE AS CO 
WHERE R.COURT_NAME='Delhi High Court'
AND JD.JUDGE_NAME='Justice Prakash Patel'
AND CO.COMMITEE_TYPE='Finance Committee';

