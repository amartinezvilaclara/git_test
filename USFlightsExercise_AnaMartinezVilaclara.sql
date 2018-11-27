--1. Quantitat de registres de la taula de vols
SELECT COUNT(*)
	FROM flights
;


--2. Retard promig de sortida i arribada segons l'aeroport
 SELECT  Origin, avg(arrDelay) ,avg(depDelay)
	From flights
	group by Origin
;

--3. Retard promig d’arribada dels vols, per mesos i segons l’aeroport origen
SELECT CONCAT_WS(', ', Origin, colYear, colMonth, avg(arrDelay))
	FROM flights
	GROUP BY Origin, colYear, colMonth
    ORDER BY Origin, colYear, colMonth
;

--4. Retard promig d’arribada dels vols, per mesos i segons l’aeroport origen (mateixa
--consulta que abans i amb el mateix ordre). Pero a més, ara volen que en comptes
--del codi de l’aeroport es mostri el nom de la ciutat
SELECT CONCAT_WS(', ', ua.Airport, colYear, colMonth, avg(arrDelay))
	FROM flights AS f 
		JOIN usairports AS ua
		ON f.Origin= ua.IATA
	GROUP BY Origin, colYear, colMonth
    ORDER BY Origin, colYear, colMonth
;

--5. Les companyies amb més vols cancelats. A més, han d’estar ordenades de forma
-- que les companyies amb més cancelacions apareguin les primeres.
SELECT Count(*) AS "Number of Cancelled Flights", UniqueCarrier
	FROM flights
	WHERE Cancelled = '1'
	GROUP BY UniqueCarrier
	ORDER BY UniqueCarrier DESC LIMIT 10
;

----------------->>Alternativa
SELECT Count(*) AS "Number of Cancelled Flights", f.UniqueCarrier, c.Description
	FROM flights AS f 
		JOIN carriers AS c 
		ON f.UniqueCarrier = c.CarrierCode
	WHERE Cancelled = '1'
	GROUP BY UniqueCarrier
	ORDER BY UniqueCarrier DESC LIMIT 10
;

--6. L’identificador dels 10 avions que més distancia han recorregut fent vols.
SELECT SUM(Distance) AS "Total flown Miles", TailNum
	FROM flights
	GROUP BY TailNum
	ORDER BY SUM(Distance) DESC LIMIT 10 OFFSET 1
;
-- NOTA: S'ha eliminat el primer resultat pk es la suma de distances dels vols NA (no se sap el TailNum)

--7. Companyies amb el seu retard promig només d’aquelles les quals els seus vols
-- arriben al seu destí amb un retras promig major de 10 minuts.
SELECT a.UniqueCarrier, c.Description, AVG(ArrDelay)
	FROM flights AS a
		JOIN carriers AS c 
		ON a.UniqueCarrier = c.CarrierCode
	WHERE 10 < (SELECT AVG (ArrDelay) FROM flights AS b WHERE a.UniqueCarrier = b.UniqueCarrier)
	GROUP BY UniqueCarrier
;
