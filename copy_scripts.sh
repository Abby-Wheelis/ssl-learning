#!/usr/bin/env bash
# Could not find private key for given certificate: "/ext/dist/etc/everest/certs/client/cso/CPO_CERT_CHAIN.pem"(SECC_LEAF) key path: "/ext/dist/etc/everest/certs/client/cso"
# Could not find private key for given certificate: "/ext/dist/etc/everest/certs/client/cso/SECC_LEAF.pem"(SECC_LEAF) key path: "/ext/dist/etc/everest/certs/client/cso"
# Could not find private key for the valid certificate

echo "copying the certs into place"
cp /tmp/new_vehicle_certs/VEHICLE_LEAF.der /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_LEAF.der
cp /tmp/new_vehicle_certs/VEHICLE_LEAF.pem /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_LEAF.pem
cp /tmp/new_vehicle_certs/VEHICLE_CERT_CHAIN.pem /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_CERT_CHAIN.pem
cp /tmp/new_vehicle_certs/VEHICLE_SUB_CA2.der /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA2.der
cp /tmp/new_vehicle_certs/VEHICLE_SUB_CA2.pem /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA2.pem
cp /tmp/new_vehicle_certs/VEHICLE_SUB_CA1.der /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA1.der
cp /tmp/new_vehicle_certs/VEHICLE_SUB_CA1.pem /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA1.pem
cp /tmp/new_vehicle_certs/V2G_ROOT_CA.der /ext/dist/etc/everest/certs/ca/v2g/V2G_ROOT_CA.der
cp /tmp/new_vehicle_certs/V2G_ROOT_CA.pem /ext/dist/etc/everest/certs/ca/v2g/V2G_ROOT_CA.pem
cp /tmp/new_vehicle_certs/V2G_CA_BUNDLE.pem /ext/dist/etc/everest/certs/ca/v2g/V2G_CA_BUNDLE.pem

#CPO
cp /tmp/new_vehicle_certs/SECC_LEAF.der /ext/dist/etc/everest/certs/client/cso/SECC_LEAF.der
cp /tmp/new_vehicle_certs/SECC_LEAF.pem /ext/dist/etc/everest/certs/client/cso/SECC_LEAF.pem
cp /tmp/new_vehicle_certs/CPO_SUB_CA2.der /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA2.der
cp /tmp/new_vehicle_certs/CPO_SUB_CA1.der /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA1.der
cp /tmp/new_vehicle_certs/CPO_SUB_CA1.pem /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA1.pem
cp /tmp/new_vehicle_certs/CPO_SUB_CA2.pem /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA2.pem

cp /tmp/new_vehicle_certs/CPO_SUB_CA2.der /ext/dist/etc/everest/certs/ca/csms/CPO_SUB_CA2.der
cp /tmp/new_vehicle_certs/CPO_SUB_CA1.der /ext/dist/etc/everest/certs/ca/csms/CPO_SUB_CA1.der
cp /tmp/new_vehicle_certs/CPO_SUB_CA1.pem /ext/dist/etc/everest/certs/ca/csms/CPO_SUB_CA1.pem
cp /tmp/new_vehicle_certs/CPO_SUB_CA2.pem /ext/dist/etc/everest/certs/ca/csms/CPO_SUB_CA2.pem

#CPS
cp /tmp/new_vehicle_certs/CPS_LEAF.der /ext/dist/etc/everest/certs/client/cps/CPS_LEAF.der
cp /tmp/new_vehicle_certs/CPS_SUB_CA2.der /ext/dist/etc/everest/certs/ca/cps/CPS_SUB_CA2.der
cp /tmp/new_vehicle_certs/CPS_SUB_CA1.der /ext/dist/etc/everest/certs/ca/cps/CPS_SUB_CA1.der

echo "copying the keys in too!"
cp /tmp/new_vehicle_certs/SECC_LEAF.key /ext/dist/etc/everest/certs/client/cso/SECC_LEAF.key

# set up certificates
echo "copying certs into csms configs"
cat /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_LEAF.pem \
    /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA2.pem \
    /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA1.pem \
  > /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_CERT_CHAIN.pem

cat /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA2.pem \
    /ext/dist/etc/everest/certs/ca/vehicle/VEHICLE_SUB_CA1.pem \
  > /ext/dist/etc/everest/certs/client/vehicle/trust.pem

cat /ext/dist/etc/everest/certs/client/cso/SECC_LEAF.pem \
    /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA2.pem \
    /ext/dist/etc/everest/certs/ca/cso/CPO_SUB_CA1.pem \
  > /ext/dist/etc/everest/certs/client/cso/CPO_CERT_CHAIN.pem

cp /ext/dist/etc/everest/certs/client/csms/CSMS_LEAF.key /ext/source/config/certs/csms.key
cp /ext/dist/etc/everest/certs/ca/v2g/V2G_ROOT_CA.pem /ext/source/config/certs/root-V2G-cert.pem
cp /ext/dist/etc/everest/certs/ca/mo/MO_ROOT_CA.pem /ext/source/config/certs/root-MO-cert.pem

echo "Validating that the certificates are set up correctly"
openssl verify -show_chain \
    -CAfile /ext/source/config/certs/root-V2G-cert.pem \
    -untrusted /ext/dist/etc/everest/certs/client/vehicle/trust.pem \
   /ext/dist/etc/everest/certs/client/vehicle/VEHICLE_CERT_CHAIN.pem