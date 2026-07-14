from decimal import Decimal

from grader import QueryResult, results_equal, rows_equal, unordered_equal


def test_numeric_tolerance_and_null_comparison() -> None:
    assert rows_equal((Decimal("2.00"), None), (2.0000001, None))


def test_unordered_comparison_preserves_duplicates() -> None:
    assert unordered_equal([(1,), (1,), (2,)], [(2,), (1,), (1,)])
    assert not unordered_equal([(1,), (1,)], [(1,)])


def test_duplicate_rule_can_ignore_repeated_rows() -> None:
    expected = QueryResult(("id",), [(1,), (1,)])
    actual = QueryResult(("id",), [(1,)])
    assert results_equal(expected, actual, {"duplicates_matter": False, "ordering_required": False})
