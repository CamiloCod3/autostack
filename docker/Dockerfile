FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Copy setup scripts and make them executable
COPY modules/odoo/setup-scripts /root/setup-scripts
RUN chmod +x /root/setup-scripts/*.sh

# Copy autostack setup script and make it executable
COPY autostack_setup.sh /root/autostack_setup.sh
RUN chmod +x /root/autostack_setup.sh

# Copy entrypoint script and make it executable
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /root/setup-scripts

# Set the entrypoint to run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
