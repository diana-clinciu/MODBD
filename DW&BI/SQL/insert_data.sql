DECLARE
    v_limit_rezervari CONSTANT NUMBER := 50000;
    v_limit_clienti   CONSTANT NUMBER := 500;
    v_limit_camere    CONSTANT NUMBER := 5000;
    v_start_date               DATE   := DATE '2023-01-01';

    v_clasa_tmp                VARCHAR2(20);
    v_categ_tmp                VARCHAR2(20);
    v_tip_tmp                  VARCHAR2(20);
    v_pret_tmp                 NUMBER;

    v_id_client_sel            NUMBER;
    v_id_camera                NUMBER;
    v_data_s                   DATE;
    v_data_f                   DATE;
    v_nr_nopti                 NUMBER;
    v_pret_cam_sel             NUMBER;
    v_pret_total               NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 1. STERGERE DATE VECHI ---');
    DELETE FROM plata;
    DELETE FROM rezervare_camera;
    DELETE FROM client_serviciu;
    DELETE FROM eveniment_client;
    DELETE FROM angajat;
    DELETE FROM rezervare;
    DELETE FROM camera;
    DELETE FROM client;
    DELETE FROM serviciu;
    DELETE FROM eveniment;

    DBMS_OUTPUT.PUT_LINE('--- 2. GENERARE CAMERE ---');
    FOR i IN 1..v_limit_camere
        LOOP
            -- Logica pentru tipul camerei
            IF DBMS_RANDOM.VALUE(0, 1) > 0.7 THEN
                v_clasa_tmp := 'Luxury';
                CASE ROUND(DBMS_RANDOM.VALUE(1, 2))
                    WHEN 1 THEN v_categ_tmp := 'Deluxe';
                    WHEN 2 THEN v_categ_tmp := 'Royal';
                    END CASE;
            ELSE
                v_clasa_tmp := 'Standard';
                CASE ROUND(DBMS_RANDOM.VALUE(1, 3))
                    WHEN 1 THEN v_categ_tmp := 'Basic';
                    WHEN 2 THEN v_categ_tmp := 'Economy';
                    ELSE v_categ_tmp := 'Family';
                    END CASE;
            END IF;
            v_pret_tmp := ROUND(DBMS_RANDOM.VALUE(150, 1050));

            CASE ROUND(DBMS_RANDOM.VALUE(1, 3))
                WHEN 1 THEN v_tip_tmp := 'Single';
                WHEN 2 THEN v_tip_tmp := 'Double';
                ELSE v_tip_tmp := 'Suite';
                END CASE;

            INSERT INTO camera (id_camera, nr_camera, tip_camera, categorie_camera, clasa_confort, pret)
            VALUES (i, 1000 + i, v_tip_tmp, v_categ_tmp, v_clasa_tmp, v_pret_tmp);
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- 3. GENERARE CLIENTI ---');
    FOR i IN 1..v_limit_clienti
        LOOP
            INSERT INTO client (id_client, nume, prenume, email)
            VALUES (i, 'Nume Client' || i, 'Prenume Client' || i, 'client' || i || '@hotel.ro');
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- 4. GENERARE REZERVARI (' || v_limit_rezervari || ') ---');

    FOR i IN 1..v_limit_rezervari
        LOOP
            -- Data random
            v_data_s := v_start_date + TRUNC(DBMS_RANDOM.VALUE(0, 1000));
            v_nr_nopti := ROUND(DBMS_RANDOM.VALUE(1, 10));
            v_data_f := v_data_s + v_nr_nopti;

            -- Selectam un client random existent (intre 1 si v_limit_clienti)
            v_id_client_sel := ROUND(DBMS_RANDOM.VALUE(1, v_limit_clienti));

            INSERT INTO rezervare (id_rezervare, id_client, data_start, data_final)
            VALUES (i, v_id_client_sel, v_data_s, v_data_f);

            -- Alegem o camera random (intre 1 si v_limit_camere)
            v_id_camera := ROUND(DBMS_RANDOM.VALUE(1, v_limit_camere));

            SELECT pret INTO v_pret_cam_sel FROM camera WHERE id_camera = v_id_camera;
            v_pret_total := v_pret_cam_sel * v_nr_nopti;

            INSERT INTO rezervare_camera (id_rezervare, id_camera, nr_nopti, pret_rezervare)
            VALUES (i, v_id_camera, v_nr_nopti, v_pret_total);

            INSERT INTO plata (id_plata, id_rezervare, suma, data_plata, metoda_plata)
            VALUES (i,
                    i,
                    0, -- Triggerul va calcula suma reala, punem 0 temporar
                    v_data_s,
                    DECODE(ROUND(DBMS_RANDOM.VALUE(1, 3)), 1, 'Card', 2, 'Cash', 'Transfer'));

            -- Commit periodic
            IF MOD(i, 2000) = 0 THEN
                COMMIT;
            END IF;
        END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- FINALIZAT CU SUCCES! ---');
END;
/