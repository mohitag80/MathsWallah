# Use a small, supported Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies (use pip cache to speed up builds)
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY app /app/app

# Create a non-root user for better security
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

# Expose the port the app will run on
EXPOSE 8000

# Run with uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
