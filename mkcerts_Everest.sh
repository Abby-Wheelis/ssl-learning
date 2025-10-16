#!/bin/sh

opensslcmd() {
    LD_LIBRARY_PATH=../.. openssl $@
}

OPENSSL_CONF=../../apps/openssl.cnf
export OPENSSL_CONF

opensslcmd version

# V2G_CA_BUNDLE.pem  V2G_ROOT_CA.der  V2G_ROOT_CA.key  V2G_ROOT_CA.pem  V2G_ROOT_CA_NEW.key  V2G_ROOT_CA_NEW.pem

#generate a root CA in PER format and in der format
opensslcmd req -x509 -new -newkey rsa:4096 -keyout V2G_ROOT_CA.key -out V2G_ROOT_CA.pem -days 3650 -nodes -subj "/CN=V2G_Root_CA"

#create 2 intermediate CAs in Der format VEHICLE_SUB_CA2 and VEHICLE_SUB_CA1
opensslcmd req -new -newkey rsa:4096 -keyout VEHICLE_SUB_CA1.key -out VEHICLE_SUB_CA1.csr -nodes -subj "/CN=VEHICLE_SUB_CA1"
opensslcmd x509 -req -in VEHICLE_SUB_CA1.csr -CA V2G_ROOT_CA.pem -CAkey V2G_ROOT_CA.key -CAcreateserial -out VEHICLE_SUB_CA1.pem -days 1825 -extfile ca.cnf -extensions v3_ca
opensslcmd req -new -newkey rsa:4096 -keyout VEHICLE_SUB_CA2.key -out VEHICLE_SUB_CA2.csr -nodes -subj "/CN=VEHICLE_SUB_CA2"
opensslcmd x509 -req -in VEHICLE_SUB_CA2.csr -CA VEHICLE_SUB_CA1.pem -CAkey VEHICLE_SUB_CA1.key -CAcreateserial -out VEHICLE_SUB_CA2.pem -days 1825 -extfile ca.cnf -extensions v3_ca

#create a vehicle leaf cert in der format VEHICLE_LEAF
opensslcmd req -new -newkey rsa:4096 -keyout VEHICLE_LEAF.key -out VEHICLE_LEAF.csr -nodes -subj "/CN=VEHICLE_LEAF"
opensslcmd x509 -req -in VEHICLE_LEAF.csr -CA VEHICLE_SUB_CA2.pem -CAkey VEHICLE_SUB_CA2.key -CAcreateserial -out VEHICLE_LEAF.pem -days 1825 -extfile ca.cnf -extensions usr_cert

#create more intermediate CAs CPO_SUB_CA2 and CPO_SUB_CA1
opensslcmd req -new -newkey rsa:4096 -keyout CPO_SUB_CA1.key -out CPO_SUB_CA1.csr -nodes -subj "/CN=CPO_SUB_CA1"
opensslcmd x509 -req -in CPO_SUB_CA1.csr -CA V2G_ROOT_CA.pem -CAkey V2G_ROOT_CA.key -CAcreateserial -out CPO_SUB_CA1.pem -days 1825 -extfile ca.cnf -extensions v3_ca
opensslcmd req -new -newkey rsa:4096 -keyout CPO_SUB_CA2.key -out CPO_SUB_CA2.csr -nodes -subj "/CN=CPO_SUB_CA2"
opensslcmd x509 -req -in CPO_SUB_CA2.csr -CA CPO_SUB_CA1.pem -CAkey CPO_SUB_CA1.key -CAcreateserial -out CPO_SUB_CA2.pem -days 1825 -extfile ca.cnf -extensions v3_ca

#create SECC leaf cert in
opensslcmd req -new -newkey rsa:4096 -keyout SECC_LEAF.key -out SECC_LEAF.csr -nodes -subj "/CN=SECC_LEAF"
opensslcmd x509 -req -in SECC_LEAF.csr -CA CPO_SUB_CA2.pem -CAkey CPO_SUB_CA2.key -CAcreateserial -out SECC_LEAF.pem -days 1825 -extfile ca.cnf -extensions usr_cert

#create more intermedite CAs CPS_SUB_CA2 and CPS_SUB_CA1
opensslcmd req -new -newkey rsa:4096 -keyout CPS_SUB_CA1.key -out CPS_SUB_CA1.csr -nodes -subj "/CN=CPS_SUB_CA1"
opensslcmd x509 -req -in CPS_SUB_CA1.csr -CA V2G_ROOT_CA.pem -CAkey V2G_ROOT_CA.key -CAcreateserial -out CPS_SUB_CA1.pem -days 1825 -extfile ca.cnf -extensions v3_ca
opensslcmd req -new -newkey rsa:4096 -keyout CPS_SUB_CA2.key -out CPS_SUB_CA2.csr -nodes -subj "/CN=CPS_SUB_CA2"
opensslcmd x509 -req -in CPS_SUB_CA2.csr -CA CPS_SUB_CA1.pem -CAkey CPS_SUB_CA1.key -CAcreateserial -out CPS_SUB_CA2.pem -days 1825 -extfile ca.cnf -extensions v3_ca

#create a CPS leaf cert in der format CPS_LEAF
opensslcmd req -new -newkey rsa:4096 -keyout CPS_LEAF.key -out CPS_LEAF.csr -nodes -subj "/CN=CPS_LEAF"
opensslcmd x509 -req -in CPS_LEAF.csr -CA CPS_SUB_CA2.pem -CAkey CPS_SUB_CA2.key -CAcreateserial -out CPS_LEAF.pem -days 1825 -extfile ca.cnf -extensions usr_cert

#create a vehicle cert chain .pem file VEHICEL_CERT_CHAIN.pem
cat VEHICLE_LEAF.pem VEHICLE_SUB_CA2.pem VEHICLE_SUB_CA1.pem V2G_ROOT_CA.pem > VEHICEL_CERT_CHAIN.pem

#create a root CA bundle
cat V2G_ROOT_CA.pem VEHICLE_SUB_CA1.pem VEHICLE_SUB_CA2.pem > V2G_CA_BUNDLE.pem

# create all certs in der format
opensslcmd x509 -in V2G_ROOT_CA.pem -outform der -out V2G_ROOT_CA.der
opensslcmd x509 -in VEHICLE_SUB_CA1.pem -outform der -out VEHICLE_SUB_CA1.der
opensslcmd x509 -in VEHICLE_SUB_CA2.pem -outform der -out VEHICLE_SUB_CA2.der
opensslcmd x509 -in VEHICLE_LEAF.pem -outform der -out VEHICLE_LEAF.der
opensslcmd x509 -in CPO_SUB_CA1.pem -outform der -out CPO_SUB_CA1.der
opensslcmd x509 -in CPO_SUB_CA2.pem -outform der -out CPO_SUB_CA2.der
opensslcmd x509 -in SECC_LEAF.pem -outform der -out SECC_LEAF.der
opensslcmd x509 -in CPS_SUB_CA1.pem -outform der -out CPS_SUB_CA1.der
opensslcmd x509 -in CPS_SUB_CA2.pem -outform der -out CPS_SUB_CA2.der
opensslcmd x509 -in CPS_LEAF.pem -outform der -out CPS_LEAF.der

#copy all the certs into the new_vehicle_certs folder
cp V2G_ROOT_CA.pem new_vehicle_certs/
cp V2G_ROOT_CA.der new_vehicle_certs/
cp VEHICLE_SUB_CA1.der new_vehicle_certs/
cp VEHICLE_SUB_CA1.pem new_vehicle_certs/
cp VEHICLE_SUB_CA2.der new_vehicle_certs/
cp VEHICLE_SUB_CA2.pem new_vehicle_certs/
cp VEHICLE_LEAF.der new_vehicle_certs/
cp VEHICLE_LEAF.pem new_vehicle_certs/
cp VEHICEL_CERT_CHAIN.pem new_vehicle_certs/
cp V2G_CA_BUNDLE.pem new_vehicle_certs/
cp CPO_SUB_CA1.der new_vehicle_certs/
cp CPO_SUB_CA1.pem new_vehicle_certs/
cp CPO_SUB_CA2.der new_vehicle_certs/
cp CPO_SUB_CA2.pem new_vehicle_certs/
cp SECC_LEAF.der new_vehicle_certs/
cp SECC_LEAF.pem new_vehicle_certs/
cp CPS_SUB_CA1.der new_vehicle_certs/
cp CPS_SUB_CA1.pem new_vehicle_certs/
cp CPS_SUB_CA2.der new_vehicle_certs/
cp CPS_SUB_CA2.pem new_vehicle_certs/
cp CPS_LEAF.der new_vehicle_certs/
cp CPS_LEAF.pem new_vehicle_certs/

#actually need some keys too
cp SECC_LEAF.key new_vehicle_certs/
