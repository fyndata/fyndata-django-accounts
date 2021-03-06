import time
from typing import Any

from fd_dj_accounts import models


def generate_email_address() -> str:
    return 'user-{}@example.com'.format(time.process_time())


def create_user(**kwargs: Any) -> models.User:
    default_email_address = generate_email_address()
    defaults = {
        'email_address': default_email_address,
        'password': default_email_address + 'XveRQfEh',
    }
    defaults.update(kwargs)

    return models.User.objects.create_user(**defaults)
