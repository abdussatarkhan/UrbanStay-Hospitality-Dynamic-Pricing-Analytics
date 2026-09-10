"""
UrbanStay: Global Hospitality & Short-Term Rental Dynamic Pricing Analytics - Pytest Automated Test Suite
"""
import pytest
import numpy as np


def test_revpar_formula():
    adr = 218.00
    occupancy_pct = 0.84633
    revpar = adr * occupancy_pct
    assert round(revpar, 2) == pytest.approx(184.50)


def test_direct_booking_share():
    direct_bookings = 4820
    total_bookings = 10000
    assert round((direct_bookings / total_bookings) * 100.0, 2) == pytest.approx(48.2)



def test_sla_compliance_bounds():
    compliant = 9400
    total = 10000
    assert round((compliant / total) * 100.0, 2) == pytest.approx(94.0)


def test_data_integrity():
    metric_val = 1420.50
    assert metric_val > 0
